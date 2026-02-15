//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/unit_test_way_of_killing_someone
	var/is_ideally_gibbing = FALSE
	var/is_potentially_destructive = FALSE

/datum/unit_test_way_of_killing_someone/proc/invoke(mob/living/victim)
	return FALSE

/datum/unit_test_way_of_killing_someone/a_ton_of_brute_damage

/datum/unit_test_way_of_killing_someone/a_ton_of_brute_damage/invoke(mob/living/victim)
	victim.take_overall_damage(brute = 9999999)

/datum/unit_test_way_of_killing_someone/a_ton_of_burn_damage

/datum/unit_test_way_of_killing_someone/a_ton_of_burn_damage/invoke(mob/living/victim)
	victim.take_overall_damage(burn = 9999999)

/datum/unit_test_way_of_killing_someone/immediate_suffocation

/datum/unit_test_way_of_killing_someone/immediate_suffocation/invoke(mob/living/victim)
	victim.adjustOxyLoss(10000000)

/datum/unit_test_way_of_killing_someone/immediate_poisoning

/datum/unit_test_way_of_killing_someone/immediate_poisoning/invoke(mob/living/victim)
	victim.adjustToxLoss(10000000)

/datum/unit_test_way_of_killing_someone/drop_all_organs

/datum/unit_test_way_of_killing_someone/drop_all_organs/invoke(mob/living/victim)
	if(!iscarbon(victim))
		return FALSE
	var/mob/living/carbon/casted = victim
	for(var/obj/item/organ/organ as anything in casted.internal_organs)
		// TODO: organ update, auto remove on yank
		organ.removed()
		organ.forceMove(casted.loc)
		organ.inflict_atom_damage(99999, DAMAGE_TYPE_BRUTE, 6, ARMOR_BOMB)

/datum/unit_test_way_of_killing_someone/qdel_all_organs

/datum/unit_test_way_of_killing_someone/qdel_all_organs/invoke(mob/living/victim)
	if(!iscarbon(victim))
		return FALSE
	var/mob/living/carbon/casted = victim
	for(var/obj/item/organ/organ as anything in casted.internal_organs)
		if(!organ.integrity_enabled || (organ.integrity_flags & INTEGRITY_INDESTRUCTIBLE))
			qdel(organ)

/datum/unit_test_way_of_killing_someone/gibbing
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/gibbing/invoke(mob/living/victim)
	victim.gib()
	// don't wait just go
	if(!QDELETED(victim))
		qdel(victim)

/datum/unit_test_way_of_killing_someone/dusting
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/dusting/invoke(mob/living/victim)
	victim.dust()
	// don't wait just go
	if(!QDELETED(victim))
		qdel(victim)

// TODO: gib doesn't delete immediately so this doesn't work as we can't be waiting for them
// /datum/unit_test_way_of_killing_someone/exploding
// 	is_ideally_gibbing = TRUE

// /datum/unit_test_way_of_killing_someone/exploding/invoke(mob/living/victim)
// 	for(var/i in 1 to 100)
// 		if(QDELETED(victim))
// 			continue
// 		victim.legacy_ex_act(1)
// 		victim.Life(2, 1)
// 	if(!QDELETED(victim))
// 		stack_trace("why did you try to explode (gib) an immortal mob?")

/datum/unit_test_way_of_killing_someone/exploding_but_gently
	is_ideally_gibbing = FALSE

/datum/unit_test_way_of_killing_someone/exploding_but_gently/invoke(mob/living/victim)
	for(var/i in 1 to 100)
		if(QDELETED(victim) || IS_DEAD(victim))
			continue
		victim.Life(2, 1)
		if(QDELETED(victim) || IS_DEAD(victim))
			continue
		victim.legacy_ex_act(3)
		sleep(1)
	if(!QDELETED(victim) && !IS_DEAD(victim))
		stack_trace("why did you try to explode (kill-only) an immortal mob?")

// TODO: gib doesn't delete immediately so this doesn't work as we can't be waiting for them
// /datum/unit_test_way_of_killing_someone/actually_exploding
// 	is_ideally_gibbing = TRUE
// 	is_potentially_destructive = TRUE

// /datum/unit_test_way_of_killing_someone/actually_exploding/invoke(mob/living/victim)
// 	for(var/i in 1 to 100)
// 		if(QDELETED(victim))
// 			continue
// 		explosion(victim.loc, 4, 0, 0, 0, FALSE)
// 		sleep(1)
// 		victim.Life(2, 1)
// 	if(!QDELETED(victim))
// 		stack_trace("why did you try to explode (gib) an immortal mob?")

/datum/unit_test_way_of_killing_someone/actually_exploding_but_gently
	is_ideally_gibbing = TRUE
	is_potentially_destructive = TRUE

/datum/unit_test_way_of_killing_someone/actually_exploding_but_gently/invoke(mob/living/victim)
	for(var/i in 1 to 100)
		if(QDELETED(victim) || IS_DEAD(victim))
			continue
		victim.Life(2, 1)
		if(QDELETED(victim) || IS_DEAD(victim))
			continue
		explosion(victim.loc, 0, 0, 4, 0, FALSE)
		sleep(1)
	if(!QDELETED(victim) && !IS_DEAD(victim))
		stack_trace("why did you try to explode (kill-only) an immortal mob?")
