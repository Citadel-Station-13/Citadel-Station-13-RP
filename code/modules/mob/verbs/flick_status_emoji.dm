//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: DECLARE_MOB_VERB
/mob/verb/flick_status_emoji()
	set name = "Flick Status Emoji"
	set desc - "Flicks a status emoji on yourself."
	set category = VERB_CATEGORY_IC

	var/list/datum/status_emoji/possible = list()

	#warn impl
