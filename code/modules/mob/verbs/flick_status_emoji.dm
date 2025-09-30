//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: DECLARE_MOB_VERB
/mob/verb/flick_status_emoji()
	set name = "Flick Status Emoji"
	set desc = "Flicks a status emoji on yourself."
	set category = VERB_CATEGORY_IC

	// No filtering for now
	var/list/datum/status_emoji/possible = GLOB.status_emojis

	var/datum/status_emoji/picked = tgui_input_list(
		src,
		"Pick a status emoji to flick.",
		"Flick Status Emoji",
		possible,
	)
	if(!picked)
		return

	var/seconds = tgui_input_number(
		src,
		"How long? (seconds)",
		"Flick Status Emoji",
		10,
		60 * 5,
		1,
	)
	var/duration = round(seconds * 10, world.tick_lag)
	AddComponent(/datum/component/status_emoji, picked, duration)
	log_game("[key_name(src)] flicked a status emoji: [picked]")
