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
		qdel(organ)

/datum/unit_test_way_of_killing_someone/qdel_all_organs

/datum/unit_test_way_of_killing_someone/qdel_all_organs/invoke(mob/living/victim)
	if(!iscarbon(victim))
		return FALSE
	var/mob/living/carbon/casted = victim
	for(var/obj/item/organ/organ as anything in casted.internal_organs)
		qdel(organ)

/datum/unit_test_way_of_killing_someone/gibbing
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/gibbing/invoke(mob/living/victim)
	victim.gib()

/datum/unit_test_way_of_killing_someone/dusting
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/dusting/invoke(mob/living/victim)
	victim.dust()

/datum/unit_test_way_of_killing_someone/exploding
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/exploding/invoke(mob/living/victim)
	for(var/i in 1 to 100)
		if(!QDELETED(victim) && !IS_DEAD(victim))
			victim.legacy_ex_act(1)
	if(!QDELETED(victim) && !IS_DEAD(victim))
		stack_trace("why did you try to explode (gib) an immortal mob?")

/datum/unit_test_way_of_killing_someone/exploding_but_gently
	is_ideally_gibbing = FALSE

/datum/unit_test_way_of_killing_someone/exploding_but_gently/invoke(mob/living/victim)
	for(var/i in 1 to 100)
		if(!QDELETED(victim) && !IS_DEAD(victim))
			victim.legacy_ex_act(3)
	if(!QDELETED(victim) && !IS_DEAD(victim))
		stack_trace("why did you try to explode (kill-only) an immortal mob?")

/datum/unit_test_way_of_killing_someone/actually_exploding
	is_ideally_gibbing = TRUE
	is_potentially_destructive = TRUE

/datum/unit_test_way_of_killing_someone/actually_exploding/invoke(mob/living/victim)
	for(var/i in 1 to 100)
		if(!QDELETED(victim) && !IS_DEAD(victim))
			explosion(victim.loc, 4, 0, 0, 0, FALSE)
	if(!QDELETED(victim) && !IS_DEAD(victim))
		stack_trace("why did you try to explode (gib) an immortal mob?")

/datum/unit_test_way_of_killing_someone/actually_exploding_but_gently
	is_ideally_gibbing = TRUE
	is_potentially_destructive = TRUE

/datum/unit_test_way_of_killing_someone/actually_exploding_but_gently/invoke(mob/living/victim)
	for(var/i in 1 to 100)
		if(!QDELETED(victim) && !IS_DEAD(victim))
			explosion(victim.loc, 0, 0, 4, 0, FALSE)
	if(!QDELETED(victim) && !IS_DEAD(victim))
		stack_trace("why did you try to explode (gib) an immortal mob?")
