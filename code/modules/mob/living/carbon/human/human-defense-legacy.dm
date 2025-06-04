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

	var/siemens_coefficient = max(species.siemens_coefficient, 0)
	siemens_coefficient *= inventory.query_simple_covered_siemens_coefficient(def_zone.body_part_flags)

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
		protection += gear.fetch_armor().get_mitigation(type) * 100
	return protection

/mob/living/carbon/human/proc/getsoak_organ(var/obj/item/organ/external/def_zone, var/type)
	if(!type || !def_zone)
		return 0
	var/soaked = 0
	var/list/protective_gear = def_zone.get_covering_clothing()
	for(var/obj/item/clothing/gear in protective_gear)
		soaked += gear.fetch_armor().get_soak(type)
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

// /mob/living/carbon/human/embed(var/obj/O, var/def_zone=null)
// 	if(!def_zone) ..()

// 	var/obj/item/organ/external/affecting = get_organ(def_zone)
// 	if(affecting)
// 		affecting.embed(O)

/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if (gloves)
		gloves.add_blood(source)
		if(istype(gloves, /obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/properly_casted = gloves
			properly_casted.transfer_blood = amount
			properly_casted.bloody_hands_mob = source
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
