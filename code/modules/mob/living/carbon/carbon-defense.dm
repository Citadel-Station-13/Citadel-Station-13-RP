//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* FX *//

/mob/living/carbon/get_combat_fx_classifier(attack_type, datum/weapon, target_zone)
	if(!target_zone)
		return ..()
	var/obj/item/organ/external/hit_bodypart = get_organ(target_zone)
	if(!hit_bodypart || hit_bodypart.is_stump())
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
