//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/unit_test/subtler_anti_ghost_still_works
	var/intended_recipient_heard_subtler = FALSE
	var/unintended_recipient_heard_subtler = FALSE
	var/intended_recipient_heard_normal = FALSE
	var/unintended_recipient_heard_normal = FALSE
	var/send_str_subtler = "isnt-there-someone-you-forgot-to-ask"
	var/send_str_normal = "kynde-did-nothing-wrong"

	var/mob/speaker

/datum/unit_test/subtler_anti_ghost_still_works/Destroy()
	if(!QDELETED(speaker))
		qdel(speaker)
	speaker = null
	return ..()

/datum/unit_test/subtler_anti_ghost_still_works/Run()
	var/mob/living/carbon/human/speaker = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/listener = allocate(/mob/living/carbon/human)
	var/mob/observer/dead/the_myth_of_consensual_handholding = allocate(/mob/observer/dead)

	src.speaker = speaker
	RegisterSignal(listener, COMSIG_MOB_ON_RECEIVE_CUSTOM_EMOTE, PROC_REF(on_intended_hear))
	RegisterSignal(the_myth_of_consensual_handholding, COMSIG_MOB_ON_RECEIVE_CUSTOM_EMOTE, PROC_REF(on_unintended_hear))

	speaker.forceMove(run_loc_floor_bottom_left)

	the_myth_of_consensual_handholding.forceMove(run_loc_floor_bottom_left)
	intended_recipient_heard_normal = intended_recipient_heard_subtler = FALSE
	unintended_recipient_heard_normal = unintended_recipient_heard_subtler = FALSE
	speaker.subtler_anti_ghost_verb(send_str_subtler)
	speaker.me_verb(send_str_normal)

	if(!intended_recipient_heard_subtler)
		Fail("A person next to the couldn't hear the subtler emote")
	if(!intended_recipient_heard_normal)
		Fail("A person next to the speaker couldn't hear the normal emote")
	if(unintended_recipient_heard_subtler)
		Fail("A ghost next to the speaker could hear the subtler emote")
	if(!unintended_recipient_heard_normal)
		Fail("A ghost next to the speaker couldn't hear the normal emote")

	var/distance = world_view_max_number() + 2
	var/turf/some_distance_away = locate(the_myth_of_consensual_handholding.x + distance, the_myth_of_consensual_handholding.y + distance, the_myth_of_consensual_handholding.z)
	if(!some_distance_away)
		Fail("some_distance_away wasn't found")
	the_myth_of_consensual_handholding.forceMove(some_distance_away)
	intended_recipient_heard_normal = intended_recipient_heard_subtler = FALSE
	unintended_recipient_heard_normal = unintended_recipient_heard_subtler = FALSE
	speaker.me_verb(send_str_normal)
	speaker.subtler_anti_ghost_verb(send_str_subtler)

	if(unintended_recipient_heard_subtler)
		Fail("A ghost [distance] tiles away from the speaker could hear the subtler emote")
	if(!unintended_recipient_heard_normal)
		Fail("A ghost [distance] tiles away from the speaker couldn't hear the normal emote")

	var/turf/one_z_away = locate(the_myth_of_consensual_handholding.x, the_myth_of_consensual_handholding.y, the_myth_of_consensual_handholding.z - 1)
	if(!one_z_away)
		Fail("one_z_away wasn't found")
	the_myth_of_consensual_handholding.forceMove(one_z_away)
	intended_recipient_heard_normal = intended_recipient_heard_subtler = FALSE
	unintended_recipient_heard_normal = unintended_recipient_heard_subtler = FALSE
	speaker.me_verb(send_str_normal)
	speaker.subtler_anti_ghost_verb(send_str_subtler)

	if(unintended_recipient_heard_subtler)
		Fail("A ghost a z-level from the speaker could hear the subtler emote")
	if(!unintended_recipient_heard_normal)
		Fail("A ghost a z-level from the speaker couldn't hear the normal emote")

/datum/unit_test/subtler_anti_ghost_still_works/proc/on_intended_hear(datum/source, mob/from_mob, raw_html, subtle, anti_ghost, saycode_type)
	if(from_mob != speaker)
		return
	if(findtext_char(raw_html, send_str_normal))
		intended_recipient_heard_normal = TRUE
	else if(findtext_char(raw_html, send_str_subtler))
		intended_recipient_heard_subtler = TRUE
	else
		Fail("Intended recipient heard something other than the predicted lines: [raw_html].")

/datum/unit_test/subtler_anti_ghost_still_works/proc/on_unintended_hear(datum/source, mob/from_mob, raw_html, subtle, anti_ghost, saycode_type)
	if(from_mob != speaker)
		return
	if(findtext_char(raw_html, send_str_normal))
		unintended_recipient_heard_normal = TRUE
	else if(findtext_char(raw_html, send_str_subtler))
		unintended_recipient_heard_subtler = TRUE
	else
		Fail("Unintended recipient heard something other than the predicted lines: [raw_html].")
