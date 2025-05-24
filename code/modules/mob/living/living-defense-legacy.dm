// this file is here for compile order reasons

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
	var/mob/living/L = user
	if(!istype(L))
		return
	if(istype(L) && L.a_intent != INTENT_HELP)
		if(ai_holder) // Using disarm, grab, or harm intent is considered a hostile action to the mob's AI.
			ai_holder.react_to_attack_polaris(L)

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

// 	return 1

// TODO: return this, but we don't want this on a human-level switch
// #warn deal wit hthis
// /mob/living/carbon/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/soaked, var/hit_zone)
// 	var/obj/item/organ/external/affecting = get_organ(hit_zone)
// 	if(!affecting)
// 		return 0

// 	// Handle striking to cripple.
// 	if(user.a_intent == INTENT_DISARM)
// 		effective_force *= 0.5 //reduced effective damage_force...
// 		if(!..(I, user, effective_force, blocked, soaked, hit_zone))
// 			return 0

// 		//set the dislocate mult less than the effective force mult so that
// 		//dislocating limbs on disarm is a bit easier than breaking limbs on harm
// 		attack_joint(affecting, I, effective_force, 0.75, blocked, soaked) //...but can dislocate joints

// only left in so we have a context of the math behind embeds/pinning
// /mob/living/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
		// Begin BS12 momentum-transfer code.
		// var/mass = 1.5
		// if(istype(O, /obj/item))
		// 	var/obj/item/I = O
		// 	mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		// var/momentum = TT.speed * mass

		// if(TT.initial_turf && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
		// 	var/dir = get_dir(TT.initial_turf, src)

		// 	src.throw_at_old(get_edge_target_turf(src,dir), 1, momentum)

		// 	if(!O || !src)
		// 		return

		// 	if(is_sharp(O)) //Projectile is suitable for pinning.
		// 		if(soaked >= round(throw_damage*0.8))
		// 			return

				// TODO: rework embeds
				//Handles embedding for non-humans and simple_mobs.
				// embed(O)

				// var/turf/T = near_wall(dir,2)

				// TODO: rework pinned
				// if(T)
				// 	src.forceMove(T)
				// 	visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
				// 	src.anchored = 1
				// 	src.pinned += O


// /mob/living/proc/embed(var/obj/O, var/def_zone=null)
// 	O.loc = src
// 	src.embedded += O
// 	add_verb(src, /mob/proc/yank_out_object)

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
/mob/proc/get_evasion()
	return 0
/mob/living/get_evasion()
	var/result = evasion // First we get the 'base' evasion.  Generally this is zero.
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.evasion))
			result += M.evasion
	return result

// todo: rework
/mob/proc/get_accuracy_penalty()
	return 0
