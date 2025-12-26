//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/unit_test_way_of_killing_someone
	var/is_ideally_gibbing = FALSE
	var/is_potentially_destructive = FALSE

/datum/unit_test_way_of_killing_someone/proc/invoke(mob/living/carbon/human)

/datum/unit_test_way_of_killing_someone/a_ton_of_brute_damage

/datum/unit_test_way_of_killing_someone/a_ton_of_burn_damage

/datum/unit_test_way_of_killing_someone/immediate_suffocation

/datum/unit_test_way_of_killing_someone/immediate_poisoning

/datum/unit_test_way_of_killing_someone/drop_all_organs

/datum/unit_test_way_of_killing_someone/qdel_all_organs

/datum/unit_test_way_of_killing_someone/gibbing
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/dusting
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/exploding
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/exploding_but_gently
	is_ideally_gibbing = TRUE

/datum/unit_test_way_of_killing_someone/actually_exploding
	is_ideally_gibbing = TRUE
	is_potentially_destructive = TRUE

/datum/unit_test_way_of_killing_someone/actually_exploding_but_gently
	is_ideally_gibbing = TRUE
	is_potentially_destructive = TRUE

#warn impl all
