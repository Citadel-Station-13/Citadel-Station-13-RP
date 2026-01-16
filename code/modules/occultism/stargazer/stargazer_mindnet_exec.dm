//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * execution datum, tracks things like if they are cooperating, sends messages, etc
 */
/datum/stargazer_mindnet_exec
	/**
	 * Our registered key.
	 */
	var/dedupe_key

	/**
	 * Mindnet initiating this execution
	 */
	var/datum/stargazer_mindnet/mindnet
	/**
	 * Target mind
	 */
	var/datum/mind/target_mind

	/**
	 * Called to check if target is still valid
	 * * Called with (src)
	 */
	var/datum/callback/on_target_valid
	/**
	 * Called with any unhandled Topic()
	 * * Called with (src, mob/user, list/href_list)
	 * * Make sure you sanitize input on your end.
	 */
	var/datum/callback/on_unhandled_topic

	/**
	 * Did the target cooperate?
	 */
	var/is_cooperative
	/**
	 * How long the target has to give cooperation.
	 */
	var/cooperate_prompt_timeout = 15 SECONDS


/datum/stargazer_mindnet_exec/New(dedupe_key)
	src.dedupe_key = dedupe_key || num2text(rand(1, 999999), 16)

/**
 * * Passed in link should have a `%%COOPERATE%%` inside it which will be
 *   replaced with the cooperate link in chat.
 */
/datum/stargazer_mindnet_exec/proc/set_chat_prompt(format)

/**
 * Keeps us alive for atleast this much more time.
 * * Used to stop an exec from being qdel'd even after the cooperation prompt is done.
 */
/datum/stargazer_mindnet_exec/proc/keep_alive_for(time)

#warn impl
