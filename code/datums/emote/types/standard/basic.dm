//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Basic emotes that just emit a simple message or something.
 */
/datum/emote/standard/basic
	abstract_type = /datum/emote/standard/basic

	//* Feedback *//

	/// if existing, we jump priority 1 to "[user] [feedback_direct]"
	var/feedback_1_direct_append
	/// if existing, we jump priority 2 to "[replacetext(feedback_user_replace, "%USER%", "[user]")]"
	var/feedback_2_user_replace

#warn impl



