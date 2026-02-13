//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* WARNING: THESE ARE DESTRUCTIVE TESTS. THESE WILL CAUSE DAMAGE TO THE TEST AREA. *//

/datum/unit_test/resleeving
	abstract_type = /datum/unit_test/resleeving
	reset_room_after = TRUE

/datum/unit_test/resleeving/mirror_general_testing
	abstract_type = /datum/unit_test/resleeving/mirror_general_testing
	var/should_exist = TRUE

/datum/unit_test/resleeving/mirror_general_testing/proc/create_character(atom/loc) as /mob/living
	CRASH("unimplemented")

/datum/unit_test/resleeving/mirror_general_testing/Run()
	var/turf/where = pick(block(run_loc_floor_bottom_left, run_loc_floor_top_right))
	var/mob/living/created_mob = create_character(where)

	var/api_supported = created_mob.resleeving_supports_mirrors()
	if(!api_supported)
		// For now, API support does not actually enforce not creating it.
		return

	var/obj/item/organ/internal/mirror/created = created_mob.resleeving_create_mirror()
	// make sure api support isn't lying
	if(api_supported && !created)
		TEST_FAIL("resleeving API supported but mirror was not made")
		return

	// make sure we can get it
	var/obj/item/organ/internal/mirror/fetched = created_mob.resleeving_get_mirror()
	if(fetched != created)
		// shouldn't happen even if technically API-legal
		TEST_FAIL("mirror didn't match between get and create")

	if(!should_exist)
		if(fetched)
			TEST_FAIL("mirror was successfully made when it shouldn't be")
			return
		// done if it shouldn't exist and doesn't exist
		return
	else
		if(!fetched)
			TEST_FAIL("mirror was not made when it should be")
			return

	// make sure admin revives don't obliterate it
	if(should_exist)
		created_mob.revive(TRUE, TRUE, TRUE)
		if(QDELETED(fetched))
			TEST_FAIL("mirror was erased by admin revive")
			return

	// make sure admin deletions nuke the mirror
	QDEL_NULL(created_mob)
	if(!QDELETED(fetched))
		TEST_FAIL("mirror wasn't properly qdeleted by a qdel() of the mob rather than death")
	fetched = null
	created = null

	// and now, for the destructive tests
	for(var/datum/unit_test_way_of_killing_someone/death_typepath as anything in subtypesof(/datum/unit_test_way_of_killing_someone))
		if(death_typepath.abstract_type == death_typepath)
			continue
		var/datum/unit_test_way_of_killing_someone/death = new death_typepath
		var/mob/victim = create_character(where)
		victim.resleeving_create_mirror()
		var/obj/item/organ/internal/mirror/mirror = victim.resleeving_get_mirror()
		if(QDELETED(mirror))
			TEST_FAIL("on death type [death_typepath] victim didn't have (or had deleted) mirror prior to invoke")
		death.invoke(victim)
		if(QDELETED(mirror))
			TEST_FAIL("on death type [death_typepath] victim got mirror deleted")
		else if(get_dist(get_turf(mirror), where) > 5)
			TEST_FAIL("on death type [death_typepath] victim mirror wasn't within 5 tiles of victim death")
		// TODO: also check for retrievability; if victim is deleted mirror should be on ground
		//       or in an organ, if victim isn't the mirror should be in a well known location
		if(!QDELETED(victim))
			qdel(victim)
		qdel(death)

/datum/unit_test/resleeving/mirror_general_testing/human

/datum/unit_test/resleeving/mirror_general_testing/human/create_character(atom/loc)
	return new /mob/living/carbon/human(loc)

/datum/unit_test/resleeving/mirror_general_testing/human/synth

/datum/unit_test/resleeving/mirror_general_testing/human/synth/create_character(atom/loc)
	var/mob/living/carbon/human/created = ..()
	var/obj/item/organ/internal/brain/brain = locate() in created.internal_organs
	brain.robotize()
	ASSERT(locate(/obj/item/organ/internal/mmi_holder) in created.internal_organs)
	return created

/datum/unit_test/resleeving/mirror_general_testing/human/protean
	should_exist = FALSE

/datum/unit_test/resleeving/mirror_general_testing/human/protean/create_character(atom/loc)
	var/mob/living/carbon/human/created = ..()
	created.set_species(/datum/species/protean)
	ASSERT(locate(/obj/item/organ/internal/mmi_holder/posibrain/nano) in created.internal_organs)
	return created

/datum/unit_test/resleeving/non_mirrorable_species_shall_be_recoverable
	abstract_type = /datum/unit_test/resleeving/non_mirrorable_species_shall_be_recoverable

/datum/unit_test/resleeving/non_mirrorable_species_shall_be_recoverable/proc/create_character(atom/loc) as /mob
	CRASH("unimplemented")

/datum/unit_test/resleeving/non_mirrorable_species_shall_be_recoverable/Run()
	var/turf/where = pick(block(run_loc_floor_bottom_left, run_loc_floor_top_right))

	// and now, for the destructive tests
	for(var/datum/unit_test_way_of_killing_someone/death_typepath as anything in subtypesof(/datum/unit_test_way_of_killing_someone))
		if(death_typepath.abstract_type == death_typepath)
			continue
		// how the fuck do you intend to get their shit back if you directly qdel?
		if(death_typepath == /datum/unit_test_way_of_killing_someone/qdel_all_organs)
			continue
		var/datum/unit_test_way_of_killing_someone/death = new death_typepath
		var/mob/victim = create_character(where)
		invoke_death_and_check_victim_recoverable(victim, death)
		if(!QDELETED(victim))
			qdel(victim)
		qdel(death)

/datum/unit_test/resleeving/non_mirrorable_species_shall_be_recoverable/proc/invoke_death_and_check_victim_recoverable(datum/unit_test_way_of_killing_someone/method)
	CRASH("unimplemented")

/datum/unit_test/resleeving/non_mirrorable_species_shall_be_recoverable/protean

/datum/unit_test/resleeving/non_mirrorable_species_shall_be_recoverable/protean/create_character(atom/loc)
	var/mob/living/carbon/human/created = new /mob/living/carbon/human(loc)
	created.set_species(/datum/species/protean)
	var/posi = locate(/obj/item/organ/internal/mmi_holder/posibrain/nano) in created.internal_organs
	ASSERT(posi)
	return created

/datum/unit_test/resleeving/non_mirrorable_species_shall_be_recoverable/protean/invoke_death_and_check_victim_recoverable(mob/living/carbon/human/char, datum/unit_test_way_of_killing_someone/method)
	var/turf/initial_loc = get_turf(char)
	if(!initial_loc)
		TEST_FAIL("no initial loc")
		return
	var/obj/item/organ/internal/mmi_holder/mmi_holder = locate() in char.internal_organs
	var/obj/item/mmi/mmi_stored = mmi_holder.stored_mmi
	if(!mmi_stored)
		TEST_FAIL("couldn't find stored mmi")
		return
	method.invoke(char)
	if(QDELETED(mmi_stored))
		TEST_FAIL("on method [method], stored mmi was deleted")
		return
	if(get_dist(mmi_stored, initial_loc) > 7 || (get_z(mmi_stored) != get_z(initial_loc)))
		TEST_FAIL("mmi stored out of bounds")
		return
	// pass
