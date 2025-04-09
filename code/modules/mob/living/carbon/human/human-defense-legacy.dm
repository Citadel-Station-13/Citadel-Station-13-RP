/mob/living/carbon/human/legacy_mob_armor(var/def_zone, var/type)
	var/armorval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getarmor_organ(def_zone, type)
		var/obj/item/organ/external/affecting = get_organ(def_zone)
		if(affecting)
			return getarmor_organ(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/organ_name in organs_by_name)
		if (organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				armorval += (getarmor_organ(organ, type) * weight)
				total += weight
	return (armorval/max(total, 1))

//Like legacy_mob_armor, but the value it returns will be numerical damage reduction
/mob/living/carbon/human/legacy_mob_soak(var/def_zone, var/type)
	var/soakval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getsoak_organ(def_zone, type)
		var/obj/item/organ/external/affecting = get_organ(def_zone)
		if(affecting)
			return getsoak_organ(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/organ_name in organs_by_name)
		if (organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				soakval += getsoak_organ(organ, type) * weight
				total += weight
	return (soakval/max(total, 1))

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = max(species.siemens_coefficient,0)

	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.body_cover_flags & def_zone.body_part_flags)) // Is that body part being targeted covered?
			siemens_coefficient *= C.siemens_coefficient

	// Modifiers.
	for(var/thing in modifiers)
		var/datum/modifier/M = thing
		if(!isnull(M.siemens_coefficient))
			siemens_coefficient *= M.siemens_coefficient

	return siemens_coefficient

// Similar to above but is for the mob's overall protection, being the average of all slots.
/mob/living/carbon/human/proc/get_siemens_coefficient_average()
	var/siemens_value = 0
	var/total = 0
	for(var/organ_name in organs_by_name)
		if(organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				siemens_value += get_siemens_coefficient_organ(organ) * weight
				total += weight

	if(fire_stacks < 0) // Water makes you more conductive.
		siemens_value *= 1.5

	return (siemens_value/max(total, 1))

// Returns a list of clothing that is currently covering def_zone.
/mob/living/carbon/human/proc/get_clothing_list_organ(var/obj/item/organ/external/def_zone, var/type)
	var/list/results = list()
	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.body_cover_flags & def_zone.body_part_flags))
			results.Add(C)
	return results

//this proc returns the armour value for a particular external organ.
/mob/living/carbon/human/proc/getarmor_organ(var/obj/item/organ/external/def_zone, var/type)
	if(!type || !def_zone)
		return 0
	var/protection = 0
	var/list/protective_gear = def_zone.get_covering_clothing()
	for(var/obj/item/clothing/gear in protective_gear)
		protection += gear.fetch_armor().raw(type) * 100
	return protection

/mob/living/carbon/human/proc/getsoak_organ(var/obj/item/organ/external/def_zone, var/type)
	if(!type || !def_zone)
		return 0
	var/soaked = 0
	var/list/protective_gear = def_zone.get_covering_clothing()
	for(var/obj/item/clothing/gear in protective_gear)
		soaked += gear.fetch_armor().soak(type)
	return soaked

// Checked in borer code
/mob/living/carbon/human/proc/check_head_coverage()
	var/obj/item/organ/external/H = organs_by_name[BP_HEAD]
	var/list/body_parts = H.get_covering_clothing(EYES)
	if(LAZYLEN(body_parts))
		return 1
	return 0

//Used to check if they can be fed food/drinks/pills
/mob/living/carbon/human/proc/check_mouth_coverage()
	var/obj/item/organ/external/H = organs_by_name[BP_HEAD]
	var/list/protective_gear = H.get_covering_clothing(FACE)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_cover_flags & FACE) && !(gear.clothing_flags & FLEXIBLEMATERIAL))
			return gear
	return null

/mob/living/carbon/human/proc/check_mouth_coverage_survival()
	var/obj/item/organ/external/H = organs_by_name[BP_HEAD]
	var/list/protective_gear = H.get_covering_clothing(FACE)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_cover_flags & FACE) && !(gear.clothing_flags & FLEXIBLEMATERIAL) && !(gear.clothing_flags & ALLOW_SURVIVALFOOD))
			return gear
	return null

/mob/living/carbon/human/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	SEND_SIGNAL(src, COMSIG_MOB_LEGACY_RESOLVE_ITEM_ATTACK, I, user, target_zone)
	if(check_neckgrab_attack(I, user, target_zone))
		return null

	if(user == src) // Attacking yourself can't miss
		return target_zone

	var/hit_zone = get_zone_with_miss_chance(target_zone, src, user.get_accuracy_penalty())

	if(!hit_zone)
		return null

	var/shieldcall_results = atom_shieldcall_handle_item_melee(I, new /datum/event_args/actor/clickchain(user), FALSE, NONE)
	// todo: clickchain should be checked for damage mult
	if(shieldcall_results & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		return

	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if (!affecting || affecting.is_stump())
		to_chat(user, "<span class='danger'>They are missing that limb!</span>")
		return null

	return hit_zone

/mob/living/carbon/human/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return //should be prevented by attacked_with_item() but for sanity.

	var/soaked = get_armor_soak(hit_zone, "melee", I.armor_penetration)

	var/blocked = run_armor_check(hit_zone, "melee", I.armor_penetration, "Your armor has protected your [affecting.name].", "Your armor has softened the blow to your [affecting.name].")

	standard_weapon_hit_effects(I, user, effective_force, blocked, soaked, hit_zone)

	return blocked

/mob/living/carbon/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/soaked, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return 0

	if(soaked >= round(effective_force*0.8))
		effective_force -= round(effective_force*0.8)
	// Handle striking to cripple.
	if(user.a_intent == INTENT_DISARM)
		effective_force *= 0.5 //reduced effective damage_force...
		if(!..(I, user, effective_force, blocked, soaked, hit_zone))
			return 0

		//set the dislocate mult less than the effective force mult so that
		//dislocating limbs on disarm is a bit easier than breaking limbs on harm
		attack_joint(affecting, I, effective_force, 0.75, blocked, soaked) //...but can dislocate joints
	else if(!..())
		return 0

	if(effective_force > 10 || effective_force >= 5 && prob(33))
		forcesay(hit_appends)	//forcesay checks stat already

	// you can't bleed, if you have no blood
	var/can_bleed = !(species.species_flags & NO_BLOOD)

	if(prob(25 + (effective_force * 2)))
		if(!((I.damage_type == DAMAGE_TYPE_BRUTE) || (I.damage_type == DAMAGE_TYPE_HALLOSS)))
			return

		if(!(I.atom_flags & NOBLOODY) && can_bleed)
			I.add_blood(src)

		var/bloody = 0
		if(can_bleed && prob(33))
			bloody = 1
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) <= 1) //people with MUTATION_TELEKINESIS won't get smeared with blood
					H.bloody_body(src)
					H.bloody_hands(src)

		if(!stat)
			switch(hit_zone)
				if("head")//Harder to score a stun but if you do it lasts a bit longer
					if(prob(effective_force))
						apply_effect(20, PARALYZE, blocked, soaked)
						visible_message("<span class='danger'>\The [src] has been knocked unconscious!</span>")
					if(bloody)//Apply blood
						if(wear_mask)
							wear_mask.add_blood(src)
							update_inv_wear_mask(0)
						if(head)
							head.add_blood(src)
							update_inv_head(0)
						if(glasses && prob(33))
							glasses.add_blood(src)
							update_inv_glasses(0)
				if("chest")//Easier to score a stun but lasts less time
					if(prob(effective_force + 10))
						apply_effect(6, WEAKEN, blocked, soaked)
						visible_message("<span class='danger'>\The [src] has been knocked down!</span>")
					if(bloody)
						bloody_body(src)

	return 1

/mob/living/carbon/human/proc/attack_joint(var/obj/item/organ/external/organ, var/obj/item/W, var/effective_force, var/dislocate_mult, var/blocked, var/soaked)
	if(!organ || (organ.dislocated == 2) || (organ.dislocated == -1) || blocked >= 100)
		return 0

	if(W.damage_type != DAMAGE_TYPE_BRUTE)
		return 0

	if(soaked >= round(effective_force*0.8))
		effective_force -= round(effective_force*0.8)

	//want the dislocation chance to be such that the limb is expected to dislocate after dealing a fraction of the damage needed to break the limb
	var/dislocate_chance = effective_force/(dislocate_mult * organ.min_broken_damage)*100
	if(prob(dislocate_chance * (100 - blocked)/100))
		visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		organ.dislocate(1)
		return 1
	return 0

/mob/living/carbon/human/emag_act(var/remaining_charges, mob/user, var/emag_source)
	var/obj/item/organ/external/affecting = get_organ(user.zone_sel.selecting)
	if(!affecting || !(affecting.robotic >= ORGAN_ROBOT))
		to_chat(user, "<span class='warning'>That limb isn't robotic.</span>")
		return -1
	if(affecting.sabotaged)
		to_chat(user, "<span class='warning'>[src]'s [affecting.name] is already sabotaged!</span>")
		return -1
	to_chat(user, "<span class='notice'>You sneakily slide [emag_source] into the dataport on [src]'s [affecting.name] and short out the safeties.</span>")
	affecting.sabotaged = 1
	return 1

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
//	if(buckled && buckled == AM)
//		return // Don't get hit by the thing we're buckled to.

	if(istype(AM, /obj))
		var/obj/O = AM

		if(in_throw_mode && TT.speed <= THROW_SPEED_CATCHABLE)	//empty active hand and we're in throw mode
			if(CHECK_ALL_MOBILITY(src, MOBILITY_CAN_USE | MOBILITY_CAN_PICKUP))
				if(isturf(O.loc))
					if(can_catch(O))
						put_in_active_hand(O)
						visible_message("<span class='warning'>[src] catches [O]!</span>")
						throw_mode_off()
						return COMPONENT_THROW_HIT_NEVERMIND

		var/dtype = DAMAGE_TYPE_BRUTE
		if(isitem(AM))
			var/obj/item/impacting_item = AM
			dtype = impacting_item.damage_type

		var/throw_damage = O.throw_force * TT.get_damage_multiplier(src)

		var/zone
		if (istype(TT.thrower, /mob/living))
			zone = check_zone(TT.target_zone)
		else
			zone = ran_zone(BP_TORSO,75)	//Hits a random part of the body, geared towards the chest

		//check if we hit
		var/miss_chance = 15
		var/distance = get_dist(TT.initial_turf, loc)
		miss_chance = max(5 * (distance - 2), 0)
		zone = get_zone_with_miss_chance(zone, src, miss_chance, ranged_attack=1)

		var/force_pierce = FALSE
		var/no_attack = FALSE
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

		if(!zone)
			visible_message("<span class='notice'>\The [O] misses [src] narrowly!</span>")
			return COMPONENT_THROW_HIT_NEVERMIND | COMPONENT_THROW_HIT_PIERCE

		if(no_attack)
			return force_pierce? COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND : NONE

		var/obj/item/organ/external/affecting = get_organ(zone)
		var/hit_area = affecting.name

		src.visible_message("<font color='red'>[src] has been hit in the [hit_area] by [O].</font>")

		if(ismob(TT.thrower))
			add_attack_logs(TT.thrower,src,"Hit with thrown [O.name]")

		//If the armor absorbs all of the damage, skip the rest of the calculations
		var/soaked = get_armor_soak(affecting, "melee", O.armor_penetration)
		if(soaked >= throw_damage)
			to_chat(src, "Your armor absorbs the force of [O.name]!")
			return

		var/armor = run_armor_check(affecting, "melee", O.armor_penetration, "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].") //I guess "melee" is the best fit here
		if(armor < 100)
			apply_damage(throw_damage, dtype, zone, armor, soaked, is_sharp(O), has_edge(O), O)

		//thrown weapon embedded object code.
		if(dtype == DAMAGE_TYPE_BRUTE && istype(O,/obj/item))
			var/obj/item/I = O
			if (!is_robot_module(I))
				var/sharp = is_sharp(I)
				var/damage = throw_damage
				if (soaked)
					damage -= soaked
				if (armor)
					damage /= armor+1

				//blunt objects should really not be embedding in things unless a huge amount of force is involved
				var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
				var/embed_threshold = sharp? 5*I.w_class : 15*I.w_class

				//Sharp objects will always embed if they do enough damage.
				//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
				if((sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance)))
					affecting.embed(I)

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = TT.speed*mass

		if(TT.initial_turf && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(TT.initial_turf, src)

			visible_message("<font color='red'>[src] staggers under the impact!</font>","<font color='red'>You stagger under the impact!</font>")
			src.throw_at_old(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src) return

			if(O.loc == src && is_sharp(O)) //Projectile is embedded and suitable for pinning.
				var/turf/T = near_wall(dir,2)
				if(T)
					forceMove(T)
					visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
					anchored = TRUE
					pinned += O

		return force_pierce? COMPONENT_THROW_HIT_PIERCE | COMPONENT_THROW_HIT_NEVERMIND : NONE

// This does a prob check to catch the thing flying at you, with a minimum of 1%
/mob/living/carbon/human/proc/can_catch(var/obj/O)
	if(!get_active_held_item())	// If active hand is empty
		var/obj/item/organ/external/temp = organs_by_name["r_hand"]
		if (active_hand % 2)
			temp = organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			return FALSE	// The hand isn't working in the first place

	if(isitem(O))
		var/obj/item/I = O
		if(I.item_flags & ITEM_THROW_UNCATCHABLE)
			return FALSE

	// Alright, our hand works? Time to try the catching.
	var/catch_chance = 90	// Default 90% catch rate

	if(is_sharp(O))
		catch_chance -= 50	// Catching knives is hard

	catch_chance -= get_accuracy_penalty()	// Same issues with shooting a gun, or swinging a weapon

	catch_chance = clamp( catch_chance, 1,  100)

	if(prob(catch_chance))
		return TRUE
	return FALSE

/mob/living/carbon/human/embed(var/obj/O, var/def_zone=null)
	if(!def_zone) ..()

	var/obj/item/organ/external/affecting = get_organ(def_zone)
	if(affecting)
		affecting.embed(O)


/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if (gloves)
		gloves.add_blood(source)
		gloves:transfer_blood = amount
		gloves:bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(w_uniform)
		w_uniform.add_blood(source)
		update_inv_w_uniform(0)

/mob/living/carbon/human/proc/handle_suit_punctures(var/damage_type, var/damage, var/def_zone)

	// Tox and oxy don't matter to suits.
	if(damage_type != DAMAGE_TYPE_BURN && damage_type != DAMAGE_TYPE_BRUTE) return

	// The hardsuit might soak this hit, if we're wearing one.
	if(back && istype(back,/obj/item/hardsuit))
		var/obj/item/hardsuit/hardsuit = back
		hardsuit.take_hit(damage)

	// We may also be taking a suit breach.
	if(!wear_suit) return
	if(!istype(wear_suit,/obj/item/clothing/suit/space)) return
	var/obj/item/clothing/suit/space/SS = wear_suit
	var/penetrated_dam = max(0,(damage - SS.breach_threshold))
	if(penetrated_dam) SS.create_breaches(damage_type, penetrated_dam)

/mob/living/carbon/human/reagent_permeability()
	var/perm = 0

	var/list/perm_by_part = list(
		"head" = THERMAL_PROTECTION_HEAD,
		"upper_torso" = THERMAL_PROTECTION_UPPER_TORSO,
		"lower_torso" = THERMAL_PROTECTION_LOWER_TORSO,
		"legs" = THERMAL_PROTECTION_LEG_LEFT + THERMAL_PROTECTION_LEG_RIGHT,
		"feet" = THERMAL_PROTECTION_FOOT_LEFT + THERMAL_PROTECTION_FOOT_RIGHT,
		"arms" = THERMAL_PROTECTION_ARM_LEFT + THERMAL_PROTECTION_ARM_RIGHT,
		"hands" = THERMAL_PROTECTION_HAND_LEFT + THERMAL_PROTECTION_HAND_RIGHT
		)

	for(var/obj/item/clothing/C in src.get_equipped_items())
		if(C.permeability_coefficient == 1 || !C.body_cover_flags)
			continue
		if(C.body_cover_flags & HEAD)
			perm_by_part["head"] *= C.permeability_coefficient
		if(C.body_cover_flags & UPPER_TORSO)
			perm_by_part["upper_torso"] *= C.permeability_coefficient
		if(C.body_cover_flags & LOWER_TORSO)
			perm_by_part["lower_torso"] *= C.permeability_coefficient
		if(C.body_cover_flags & LEGS)
			perm_by_part["legs"] *= C.permeability_coefficient
		if(C.body_cover_flags & FEET)
			perm_by_part["feet"] *= C.permeability_coefficient
		if(C.body_cover_flags & ARMS)
			perm_by_part["arms"] *= C.permeability_coefficient
		if(C.body_cover_flags & HANDS)
			perm_by_part["hands"] *= C.permeability_coefficient

	for(var/part in perm_by_part)
		perm += perm_by_part[part]

	return perm

// This is for preventing harm by being covered in water, which only prometheans need to deal with.
// This is not actually used for now since the code for prometheans gets changed a lot.
/mob/living/carbon/human/get_water_protection()
	var/protection = ..() // Todo: Replace with species var later.
	if(protection == 1) // No point doing permeability checks if it won't matter.
		return protection
	// Wearing clothing with a low permeability_coefficient can protect from water.

	var/converted_protection = 1 - protection
	var/perm = reagent_permeability()
	converted_protection *= perm
	return 1-converted_protection


/mob/living/carbon/human/shank_attack(obj/item/W, obj/item/grab/G, mob/user, hit_zone)

	if(!..())
		return 0

	var/organ_chance = 50
	var/damage = shank_armor_helper(W, G, user)
	var/obj/item/organ/external/chest = get_organ(hit_zone)

	if(W.damage_mode & DAMAGE_MODE_EDGE)
		organ_chance = 75
	user.next_move = world.time + 20
	user.visible_message("<span class='danger'>\The [user] begins to twist \the [W] around inside [src]'s [chest]!</span>")
	if(!do_after(user, 20))
		return 0
	if(!(G && G.assailant == user && G.affecting == src)) //check that we still have a grab
		return 0

	user.visible_message("<span class='danger'>\The x[user] twists \the [W] around inside [src]'s [chest]!</span>")
	var/obj/item/organ/internal/selected_organ = pick(chest.internal_organs)
	if(istype(W,/obj/item/material/knife/stiletto))
		selected_organ.take_damage(damage * 5)
		G.last_action = world.time
		flick(G.hud.icon_state, G.hud)
		add_attack_logs(user,src,"stiletto stabbed")
	else
		if(prob(organ_chance))
			selected_organ.take_damage(damage * 0.5)
			G.last_action = world.time
			flick(G.hud.icon_state, G.hud)
			add_attack_logs(user,src,"shanked")
	return 1
