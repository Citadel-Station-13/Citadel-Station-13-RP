//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/carbon/melee_act(mob/attacker, obj/item/weapon, datum/melee_attack/weapon/style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(attacker != src)
		var/hit_zone = get_zone_with_miss_chance(target_zone, src, attacker.get_accuracy_penalty())
		if(!hit_zone)
			return CLICKCHAIN_ATTACK_MISSED
		clickchain.target_zone = target_zone = hit_zone
	var/obj/item/organ/external/affecting = get_organ(target_zone)
	if (!affecting || affecting.is_stump())
		to_chat(attacker, "<span class='danger'>They are missing that limb!</span>")
		return CLICKCHAIN_ATTACK_MISSED
	return ..()

/mob/living/carbon/on_melee_act(mob/attacker, obj/item/weapon, datum/melee_attack/attack_style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	if(weapon && check_neckgrab_attack(weapon, attacker, target_zone))
		return clickchain_flags | CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_ATTACK
	return ..()

/mob/living/carbon/on_melee_impact(mob/attacker, obj/item/weapon, datum/melee_attack/attack_style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags, list/damage_instance_results)
	..()
	var/resultant_damage = damage_instance_results[SHIELDCALL_ARG_DAMAGE]
	if(!resultant_damage)
		return
	var/resultant_damage_type = damage_instance_results[SHIELDCALL_ARG_DAMAGE_TYPE]
	if(!(damage_instance_results[SHIELDCALL_ARG_DAMAGE_MODE] & (DAMAGE_MODE_GRADUAL)) && (resultant_damage_type == DAMAGE_TYPE_BRUTE) && (resultant_damage > 1))
		var/obj/item/organ/external/bodypart = get_bodypart_for_zone(damage_instance_results[SHIELDCALL_ARG_HIT_ZONE])
		// bloody / knockout / knockdown requires non-gradual kinetic force
		var/no_bleed = (species.species_flags & NO_BLOOD) && (bodypart ? (bodypart.robotic < ORGAN_ROBOT) : !isSynthetic())
		// old calculation here for probability
		if(prob(25 + (resultant_damage * 2)))
			if(weapon && !(weapon.atom_flags & NOBLOODY))
				weapon.add_blood(src)
		// TODO: bleeding / blood backsplash frmo melee should be handled at /living level
		//       with a new proc for doing all this logic
		var/they_should_bleed = !no_bleed && prob(33)
		if(they_should_bleed)
			var/turf/location = loc
			location.add_blood(src)
			if(ishuman(attacker))
				var/mob/living/carbon/human/human_attacker = attacker
				human_attacker.bloody_body(src)
				human_attacker.bloody_hands(src)
		if(IS_CONSCIOUS(src))
			switch(BODY_ZONE_TO_SIMPLIFIED(target_zone))
				if(BODY_ZONE_HEAD)
					// requires atleast a significant hit
					if(resultant_damage > 8 && prob(resultant_damage))
						// knockout nerfed from 40 sec to 20 sec baseline
						// however, unaffected by armor for now
						// TODO: is rng knockout still acceptable?
						afflict_unconscious(20 SECONDS * clickchain.attack_melee_multiplier)
						visible_message(SPAN_DANGER("[src] has been knocked unconscious!"))
					if(they_should_bleed)
						// TODO: it should be obvious why this is bad
						var/mob/living/carbon/human/cast_to_human = src
						if(istype(cast_to_human))
							cast_to_human.wear_mask?.add_blood(src)
							cast_to_human.head?.add_blood(src)
							cast_to_human.glasses?.add_blood(src)
							cast_to_human.inventory?.update_slot_render(/datum/inventory_slot/inventory/mask::id)
							cast_to_human.inventory?.update_slot_render(/datum/inventory_slot/inventory/head::id)
							cast_to_human.inventory?.update_slot_render(/datum/inventory_slot/inventory/glasses::id)
				if(BODY_ZONE_TORSO)
					// requires a slightly less significant hit
					if(resultant_damage > 4 && prob(resultant_damage + 10))
						// nerfed from 12 seconds to 2 baseline
						afflict_paralyze(2 SECONDS * clickchain.attack_melee_multiplier)
						visible_message(SPAN_DANGER("[src] has been brutally knocked down!"))
					if(they_should_bleed)
						// TODO: it should be obvious why this is bad
						var/mob/living/carbon/human/cast_to_human = src
						if(istype(cast_to_human))
							cast_to_human.bloody_body(src)

//* FX *//

/mob/living/carbon/get_combat_fx_classifier(attack_type, datum/attack_source, target_zone)
	if(!target_zone)
		return ..()
	var/obj/item/organ/external/hit_bodypart = get_organ(target_zone)
	if(!hit_bodypart)
		return ..()
	if(BP_IS_ROBOTIC(hit_bodypart))
		return COMBAT_IMPACT_FX_METAL
	return COMBAT_IMPACT_FX_FLESH

//* Projectile Handling *//

/mob/living/carbon/process_bullet_miss(obj/projectile/proj, impact_flags, def_zone, efficiency)
	. = ..()
	if(!.)
		return
	// perform normal baymiss
	. = get_zone_with_miss_chance(., src, -10, TRUE)
	// check if we even have that organ; if not, they automatically miss
	if(!get_organ(.))
		return null

//* Misc Effects *//

/mob/living/carbon/electrocute_act(efficiency, energy, damage, stun_power, flags, hit_zone, atom/movable/source, list/shared_blackboard, out_energy_consumed)
	if(!(flags & ELECTROCUTE_ACT_FLAG_INTERNAL))
		if(species.species_flags & IS_PLANT)
			switch(hit_zone)
				if("l_hand")
					efficiency = 0
				if("r_hand")
					efficiency = 0
	return ..()

/mob/living/carbon/inflict_electrocute_damage(damage, stun_power, flags, hit_zone)
	flash_pain()
	if(damage)
		if(!hit_zone || (flags & (ELECTROCUTE_ACT_FLAG_DISTRIBUTE | ELECTROCUTE_ACT_FLAG_UNIFORM)))
			// hit beyond one part
			take_overall_damage(0, damage, null, "electrical burns")
		else
			// hit one part
			apply_damage(damage, DAMAGE_TYPE_BURN, hit_zone, used_weapon = "electrical burns")
	if(stun_power)
		adjustHalLoss(stun_power)
		if(!(flags & ELECTROCUTE_ACT_FLAG_DO_NOT_STUN) && stun_power > 20 && prob(stun_power))
			default_combat_knockdown(stun_power)
		apply_effect(STUTTER, sqrt(stun_power))
		apply_effect(EYE_BLUR, sqrt(stun_power) * 0.5)
		if(stun_power > 20)
			var/obj/item/knock_out_of_hand
			var/obj/item/organ/knock_out_of_hand_organ
			var/knock_out_descriptor
			switch(hit_zone)
				if(BP_L_HAND, BP_L_ARM)
					knock_out_of_hand = get_left_held_item()
					knock_out_of_hand_organ = get_organ(BP_L_HAND)
					knock_out_descriptor = "left hand"
				if(BP_R_HAND, BP_R_ARM)
					knock_out_of_hand = get_right_held_item()
					knock_out_of_hand_organ = get_organ(BP_R_HAND)
					knock_out_descriptor = "right hand"
			if(knock_out_of_hand && knock_out_of_hand_organ)
				if(drop_item_to_ground(knock_out_of_hand))
					if(!knock_out_of_hand_organ.organ_can_feel_pain())
						INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, custom_emote), 1, "drops what they were holding, their [knock_out_of_hand_organ.name] malfunctioning!")
					else
						var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
						INVOKE_ASYNC(src, TYPE_PROC_REF(/mob, custom_emote), 1, "[knock_out_of_hand_organ.organ_can_feel_pain() ? "" : emote_scream] drops what they were holding in their [knock_out_descriptor]!")

/mob/living/carbon/slip_act(slip_class, source, hard_strength, soft_strength, suppressed)
	. = ..()
	if(buckled)
		return 0
	tactile_feedback(SPAN_WARNING("You slipped on \the [source]!"))
	// todo: sound should be on component / tile?
	playsound(src, 'sound/misc/slip.ogg', 50, TRUE, -3)
	afflict_paralyze(hard_strength)
	afflict_knockdown(soft_strength)
