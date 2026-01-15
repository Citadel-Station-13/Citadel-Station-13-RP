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
	 * Target mind.
	 * * Notice how the target is a mind and not a mob.
	 */
	var/datum/mind/target_mind

	/**
	 * Called to check if target is still valid
	 * * Called with (src)
	 */
	var/datum/callback/on_target_valid
	/**
	 * Called to return execution to caller.
	 * * Called after cooperation prompt times out or is accepted.
	 */
	var/datum/callback/on_prompt_finish

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


#warn impl
