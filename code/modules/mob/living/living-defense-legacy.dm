/*
	run_armor_check(a,b)
	args
	a:def_zone		- What part is getting hit, if null will check entire body
	b:attack_flag	- What type of attack, bullet, laser, energy, melee
	c:armour_pen	- How much armor to ignore.
	d:absorb_text	- Custom text to send to the player when the armor fully absorbs an attack.
	e:soften_text	- Similar to absorb_text, custom text to send to the player when some damage is reduced.

	Returns
	A number between 0 and 100, with higher numbers resulting in less damage taken.
*/
/mob/living/proc/run_armor_check(var/def_zone = null, var/attack_flag = "melee", var/armour_pen = 0, var/absorb_text = null, var/soften_text = null)
	if(GLOB.Debug2)
		log_world("## DEBUG: legacy_mob_armor() was called.")

	if(armour_pen >= 100)
		return 0 //might as well just skip the processing

	var/armor = legacy_mob_armor(def_zone, attack_flag)
	if(armor)
		var/armor_variance_range = round(armor * 0.25) //Armor's effectiveness has a +25%/-25% variance.
		var/armor_variance = rand(-armor_variance_range, armor_variance_range) //Get a random number between -25% and +25% of the armor's base value
		if(GLOB.Debug2)
			log_world("## DEBUG: The range of armor variance is [armor_variance_range].  The variance picked by RNG is [armor_variance].")

		armor = min(armor + armor_variance, 100)	//Now we calcuate damage using the new armor percentage.
		armor = max(armor - armour_pen, 0)			//Armor pen makes armor less effective.
		if(armor >= 100)
			if(absorb_text)
				to_chat(src, "<span class='danger'>[absorb_text]</span>")
			else
				to_chat(src, "<span class='danger'>Your armor absorbs the blow!</span>")

		else if(armor > 0)
			if(soften_text)
				to_chat(src, "<span class='danger'>[soften_text]</span>")
			else
				to_chat(src, "<span class='danger'>Your armor softens the blow!</span>")
		if(GLOB.Debug2)
			log_world("## DEBUG: Armor when [src] was attacked was [armor].")
	return armor

/*
	//Old armor code here.
	if(armour_pen >= 100)
		return 0 //might as well just skip the processing

	var/armor = legacy_mob_armor(def_zone, attack_flag)
	var/absorb = 0

	//Roll armour
	if(prob(armor))
		absorb += 1
	if(prob(armor))
		absorb += 1

	//Roll penetration
	if(prob(armour_pen))
		absorb -= 1
	if(prob(armour_pen))
		absorb -= 1

	if(absorb >= 2)
		if(absorb_text)
			show_message("[absorb_text]")
		else
			show_message("<span class='warning'>Your armor absorbs the blow!</span>")
		return 2
	if(absorb == 1)
		if(absorb_text)
			show_message("[soften_text]",4)
		else
			show_message("<span class='warning'>Your armor softens the blow!</span>")
		return 1
	return 0
*/

//Certain pieces of armor actually absorb flat amounts of damage from income attacks
/mob/living/proc/get_armor_soak(var/def_zone = null, var/attack_flag = "melee", var/armour_pen = 0)
	var/soaked = legacy_mob_soak(def_zone, attack_flag)
	//5 points of armor pen negate one point of soak
	if(armour_pen)
		soaked = max(soaked - (armour_pen/5), 0)
	return soaked

//if null is passed for def_zone, then this should return something appropriate for all zones (e.g. area effect damage)
/mob/living/proc/legacy_mob_armor(var/def_zone, var/type)
	return 0

/mob/living/proc/legacy_mob_soak(var/def_zone, var/type)
	return 0

// Clicking with an empty hand
/mob/living/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	. = ..()
	if(.)
		return
	SEND_SIGNAL(src, COMSIG_MOB_LEGACY_ATTACK_HAND_INTERCEPT, user, e_args)
	var/mob/living/L = user
	if(!istype(L))
		return
	if(istype(L) && L.a_intent != INTENT_HELP)
		if(ai_holder) // Using disarm, grab, or harm intent is considered a hostile action to the mob's AI.
			ai_holder.react_to_attack_polaris(L)

/mob/living/rad_act(strength, datum/radiation_wave/wave)
	. = ..()
	if(wave)
		afflict_radiation(strength * RAD_MOB_ACT_COEFFICIENT - RAD_MOB_ACT_PROTECTION_PER_WAVE_SOURCE, TRUE)
	else
		afflict_radiation(strength * RAD_MOB_ACT_COEFFICIENT - RAD_MOB_ACT_PROTECTION_PER_WAVE_SOURCE, TRUE)

/mob/living/emp_act(severity)
	var/list/L = src.get_equipped_items(TRUE, TRUE)
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

/mob/living/blob_act(var/obj/structure/blob/B)
	if(stat == DEAD || has_iff_faction(MOB_IFF_FACTION_BLOB))
		return

	var/damage = rand(30, 40)
	var/armor_pen = 0
	var/armor_check = "melee"
	var/damage_type = DAMAGE_TYPE_BRUTE
	var/attack_message = "The blob attacks you!"
	var/attack_verb = "attacks"
	var/def_zone = pick(BP_HEAD, BP_TORSO, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)

	if(B && B.overmind)
		var/datum/blob_type/blob = B.overmind.blob_type

		damage = rand(blob.damage_lower, blob.damage_upper)
		armor_check = blob.armor_check
		armor_pen = blob.armor_pen
		damage_type = blob.damage_type

		attack_message = "[blob.attack_message][isSynthetic() ? "[blob.attack_message_synth]":"[blob.attack_message_living]"]"
		attack_verb = blob.attack_verb
		B.overmind.blob_type.on_attack(B, src, def_zone)

	if( (damage_type == DAMAGE_TYPE_TOX || damage_type == DAMAGE_TYPE_OXY) && isSynthetic()) // Borgs and FBPs don't really handle tox/oxy damage the same way other mobs do.
		damage_type = DAMAGE_TYPE_BRUTE
		damage *= 0.66 // Take 2/3s as much damage.

	visible_message("<span class='danger'>\The [B] [attack_verb] \the [src]!</span>", "<span class='danger'>[attack_message]!</span>")
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)

	//Armor
	var/soaked = get_armor_soak(def_zone, armor_check, armor_pen)
	var/absorb = run_armor_check(def_zone, armor_check, armor_pen)

	apply_damage(damage, damage_type, def_zone, absorb, soaked)

/mob/living/proc/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	SEND_SIGNAL(src, COMSIG_MOB_LEGACY_RESOLVE_ITEM_ATTACK, I, user, target_zone)

	var/shieldcall_results = atom_shieldcall_handle_item_melee(I, new /datum/event_args/actor/clickchain(user), FALSE, NONE)
	// todo: clickchain should be checked for damage mult
	if(shieldcall_results & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		return

	return target_zone

//Called when the mob is hit with an item in combat. Returns the blocked result
/mob/living/proc/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(ai_holder)
		ai_holder.react_to_attack_polaris(user)

	var/soaked = get_armor_soak(hit_zone, "melee")
	var/blocked = run_armor_check(hit_zone, "melee")

	standard_weapon_hit_effects(I, user, effective_force, blocked, soaked, hit_zone)

	if(I.damage_type == DAMAGE_TYPE_BRUTE && prob(33)) // Added blood for whacking non-humans too
		var/turf/simulated/location = get_turf(src)
		if(istype(location)) location.add_blood_floor(src)

	return blocked

//returns 0 if the effects failed to apply for some reason, 1 otherwise.
/mob/living/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/soaked, var/hit_zone)
	if(!effective_force || blocked >= 100)
		return 0
	//Apply weapon damage
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)

	if(legacy_mob_soak(hit_zone, "melee",) - (I.armor_penetration/5) > round(effective_force*0.8)) //soaking a hit turns sharp attacks into blunt ones
		weapon_sharp = 0
		weapon_edge = 0

	if(prob(max(legacy_mob_armor(hit_zone, "melee") - I.armor_penetration, 0))) //melee armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		weapon_sharp = 0
		weapon_edge = 0

	apply_damage(effective_force, I.damage_type, hit_zone, blocked, soaked, sharp=weapon_sharp, edge=weapon_edge, used_weapon=I)

	return 1

//this proc handles being hit by a thrown atom
/mob/living/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	if(istype(AM, /obj))
		var/obj/O = AM
		var/dtype = DAMAGE_TYPE_BRUTE
		if(isitem(AM))
			var/obj/item/impacting_item = AM
			dtype = impacting_item.damage_type
		var/throw_damage = O.throw_force * TT.get_damage_multiplier(src)

		var/miss_chance = 15
		var/distance = get_dist(TT.initial_turf, loc)
		miss_chance = max(5 * (distance - 2), 0)

		if (prob(miss_chance))
			visible_message("<font color=#4F49AF>\The [O] misses [src] narrowly!</font>")
			return COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND

		var/force_pierce = FALSE
		var/no_attack = FALSE

		var/zone
		if (istype(TT.thrower, /mob/living))
			zone = check_zone(TT.target_zone)
		else
			zone = ran_zone(BP_TORSO,75)	//Hits a random part of the body, geared towards the chest

		if(zone)
			// perform shieldcall
			// todo: reconcile all the way down to /atom, or at least a higher level than /human.
			var/retval
			for(var/datum/shieldcall/shieldcall as anything in shieldcalls)
				retval |= shieldcall.handle_throw_impact(src, TT)
				if(retval & SHIELDCALL_FLAGS_SHOULD_TERMINATE)
					break
			if(retval & SHIELDCALL_FLAGS_SHOULD_PROCESS)
				if(retval & SHIELDCALL_FLAGS_PIERCE_ATTACK)
					force_pierce = TRUE
				if(retval & SHIELDCALL_FLAGS_BLOCK_ATTACK)
					no_attack = TRUE

		if(no_attack)
			return force_pierce? COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND : NONE

		src.visible_message("<font color='red'>[src] has been hit by [O].</font>")
		var/armor = run_armor_check(null, "melee")
		var/soaked = get_armor_soak(null, "melee")


		apply_damage(throw_damage, dtype, null, armor, soaked, is_sharp(O), has_edge(O), O)

		if(ismob(TT.thrower))
			var/mob/M = TT.thrower
			// we log only if one party is a player
			if(!!client || !!M.client)
				add_attack_logs(M,src,"Hit by thrown [O.name]")
			if(ai_holder)
				ai_holder.react_to_attack_polaris(TT.thrower)

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = TT.speed * mass

		if(TT.initial_turf && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(TT.initial_turf, src)

			visible_message("<font color='red'>[src] staggers under the impact!</font>","<font color='red'>You stagger under the impact!</font>")
			src.throw_at_old(get_edge_target_turf(src,dir), 1, momentum)

			if(!O || !src)
				return

			if(is_sharp(O)) //Projectile is suitable for pinning.
				if(soaked >= round(throw_damage*0.8))
					return

				//Handles embedding for non-humans and simple_mobs.
				embed(O)

				var/turf/T = near_wall(dir,2)

				if(T)
					src.forceMove(T)
					visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
					src.anchored = 1
					src.pinned += O

		return force_pierce? COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND : NONE

/mob/living/proc/embed(var/obj/O, var/def_zone=null)
	O.loc = src
	src.embedded += O
	add_verb(src, /mob/proc/yank_out_object)

//This is called when the mob is thrown into a dense turf
/mob/living/proc/turf_collision(var/turf/T, var/speed)
	src.take_random_targeted_damage(brute = speed*5)

/mob/living/proc/near_wall(var/direction,var/distance=1)
	var/turf/T = get_step(get_turf(src),direction)
	var/turf/last_turf = src.loc
	var/i = 1

	while(i>0 && i<=distance)
		if(T.density) //Turf is a wall!
			return last_turf
		i++
		last_turf = T
		T = get_step(T,direction)

	return 0

// End BS12 momentum-transfer code.

/mob/living/attack_generic(var/mob/user, var/damage, var/attack_message)
	if(!damage)
		return

	adjustBruteLoss(damage)
	add_attack_logs(user,src,"Generic attack (probably animal)", admin_notify = FALSE) //Usually due to simple_mob attacks
	if(ai_holder)
		ai_holder.react_to_attack_polaris(user)
	src.visible_message("<span class='danger'>[user] has [attack_message] [src]!</span>")
	user.do_attack_animation(src)
	spawn(1) update_health()
	return 1

/mob/living/proc/IgniteMob()
	if(fire_stacks > 0 && !on_fire)
		on_fire = 1
		handle_light()
		update_fire()

/mob/living/carbon/human/IgniteMob()
	if(!(species.species_flags & NO_IGNITE))
		return ..()


/mob/living/proc/ExtinguishMob()
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		handle_light()
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
    fire_stacks = clamp(fire_stacks + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

/mob/living/proc/handle_fire()
	if(fire_stacks < 0)
		fire_stacks = min(0, ++fire_stacks) //If we've doused ourselves in water to avoid fire, dry off slowly

	if(fire_stacks > 0)
		fire_stacks = max(0, (fire_stacks-0.1))	//Should slowly burn out

	if(!on_fire)
		return 1
	else if(fire_stacks <= 0)
		ExtinguishMob() //Fire's been put out.
		return 1

	var/datum/gas_mixture/G = loc?.return_air() // Check if we're standing in an oxygenless environment
	if(!G || (G.gas[GAS_ID_OXYGEN] < 1))
		ExtinguishMob() //If there's no oxygen in the tile we're on, put out the fire
		return 1

	var/turf/location = get_turf(src)
	location.hotspot_expose(fire_burn_temperature(), 50, 1)

//altered this to cap at the temperature of the fire causing it, using the same 1:1500 value as /mob/living/carbon/human/handle_fire() in human/life.dm
/mob/living/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature)
		if(fire_stacks < exposed_temperature/1500) // Subject to balance
			adjust_fire_stacks(2)
	else
		adjust_fire_stacks(2)
	IgniteMob()

//Share fire evenly between the two mobs
//Called in MobCollide() and Crossed()
/mob/living/proc/spread_fire(mob/living/L)
	return

/mob/living/proc/get_cold_protection()
	return 0

/mob/living/proc/get_heat_protection()
	return 0

/mob/living/proc/get_water_protection()
	return 1 // Water won't hurt most things.

/mob/living/proc/get_poison_protection()
	return 0

//Finds the effective temperature that the mob is burning at.
/mob/living/proc/fire_burn_temperature()
	if (fire_stacks <= 0)
		return 0

	//Scale quadratically so that single digit numbers of fire stacks don't burn ridiculously hot.
	//lower limit of 700 K, same as matches and roughly the temperature of a cool flame.
	return max(2.25*round(FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE*(fire_stacks/FIRE_MAX_FIRESUIT_STACKS)**2), 700)

// Called when struck by lightning.
/mob/living/proc/lightning_act()
	// The actual damage/electrocution is handled by the tesla_zap() that accompanies this.
	afflict_unconscious(20 * 5)
	stuttering += 20
	make_jittery(150)
	emp_act(1)
	to_chat(src, SPAN_CRITICAL("You've been struck by lightning!"))

// Called when touching a lava tile.
// Does roughly 100 damage to unprotected mobs, and 20 to fully protected mobs.
/mob/living/lava_act()
	add_modifier(/datum/modifier/fire/intense, 3 SECONDS) // Around 40 total if left to burn and without fire protection per stack.
	inflict_heat_damage(10) // Another 40, however this is instantly applied to unprotected mobs.
	adjustFireLoss(10) // Lava cannot be 100% resisted with fire protection.

//Acid
/mob/living/acid_act(var/mob/living/H)
	make_dizzy(1)
	adjustHalLoss(1)
	inflict_heat_damage(5) // This is instantly applied to unprotected mobs.
	inflict_poison_damage(5)
	adjustFireLoss(5) // Acid cannot be 100% resisted by protection.
	adjustToxLoss(5)
	Confuse(1)

//Blood
//Acid
/mob/living/blood_act(var/mob/living/H)
	inflict_poison_damage(5)
	adjustToxLoss(5)


/mob/living/proc/reagent_permeability()
	return 1

// todo: rework
// Returns a number to determine if something is harder or easier to hit than normal.
/mob/living/proc/get_evasion()
	var/result = evasion // First we get the 'base' evasion.  Generally this is zero.
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.evasion))
			result += M.evasion
	return result

// todo: rework
/mob/living/proc/get_accuracy_penalty()
	return 0
