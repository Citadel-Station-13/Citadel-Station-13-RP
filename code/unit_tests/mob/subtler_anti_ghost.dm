//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/unit_test/subtler_anti_ghost_still_works
	var/intended_recipient_heard_subtler = FALSE
	var/unintended_recipient_heard_subtler = FALSE
	var/intended_recipient_heard_normal = FALSE
	var/unintended_recipient_heard_normal = FALSE
	var/shouldnt_hear_by_ghost = "isnt_there_someone_you_forgot_to_ask"
	var/should_hear_by_ghost = "kynde_did_nothing_wrong"

/datum/unit_test/subtler_anti_ghost_still_works/Run()
	var/mob/living/carbon/human/speaker = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/listener = allocate(/mob/living/carbon/human)
	var/mob/observer/dead/the_myth_of_consensual_handholding = allocate(/mob/dead/observer)
	speaker.forceMove(run_loc_floor_bottom_left)
	the_myth_of_consensual_handholding.forceMove(run_loc_floor_bottom_left)

	RegisterSignal(listener, COMSIG_MOB_ON_RECEIVE_CUSTOM_EMOTE, PROC_REF(on_intended_hear))
	RegisterSignal(the_myth_of_consensual_handholding, COMSIG_MOB_ON_RECEIVE_CUSTOM_EMOTE, PROC_REF(on_unintended_hear))

	speaker.subtler_anti_ghost_verb(shouldnt_hear_by_ghost)
	speaker.me_verb(should_hear_by_ghost)

	if(!intended_recipient_heard_subtler)
		Fail("A person next to the couldn't hear the subtler emote")
	if(!intended_recipient_heard_normal)
		Fail("A person next to the speaker couldn't hear the normal emote")
	if(unintended_recipient_heard_subtler)
		Fail("A ghost next to the speaker could hear the subtler emote")
	if(!unintended_recipient_heard_normal)
		Fail("A ghost next to the speaker couldn't hear the normal emote")

	var/distance = world_view_max_number() + 2
	the_myth_of_consensual_handholding.forceMove(locate(the_myth_of_consensual_handholding.x + distance, the_myth_of_consensual_handholding.y + distance, the_myth_of_consensual_handholding.z))
	unintended_recipient_heard_normal = FALSE
	unintended_recipient_heard_subtler = FALSE
	speaker.me_verb(should_hear_by_ghost)
	speaker.subtler_anti_ghost_verb(shouldnt_hear_by_ghost)

	if(unintended_recipient_heard_subtler)
		Fail("A ghost [distance] tiles away from the speaker could hear the subtler emote")
	if(!unintended_recipient_heard_normal)
		Fail("A ghost [distance] tiles away from the speaker couldn't hear the normal emote")

	the_myth_of_consensual_handholding.forceMove(locate(the_myth_of_consensual_handholding.x, the_myth_of_consensual_handholding.y, the_myth_of_consensual_handholding.z + 1))
	unintended_recipient_heard_normal = FALSE
	unintended_recipient_heard_subtler = FALSE
	speaker.me_verb(should_hear_by_ghost)
	speaker.subtler_anti_ghost_verb(shouldnt_hear_by_ghost)

	if(unintended_recipient_heard_subtler)
		Fail("A ghost a z-level from the speaker could hear the subtler emote")
	if(!unintended_recipient_heard_normal)
		Fail("A ghost a z-level from the speaker couldn't hear the normal emote")

/datum/unit_test/subtler_anti_ghost_still_works/proc/on_intended_hear(datum/source, raw_html, subtle, anti_ghost, saycode_type)
	#warn impl

/datum/unit_test/subtler_anti_ghost_still_works/proc/on_unintended_hear(datum/source, raw_html, subtle, anti_ghost, saycode_type)
	#warn impl
