//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * execution datum, tracks things like if they are cooperating, sends messages, etc
 */
/datum/stargazer_mindnet_exec
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
	 * Called to format what they see in chat.
	 * * Called with (src, cooperate_link)
	 */
	var/datum/callback/on_chat_fmt
	/**
	 * Called if the receiver doesn't cooperate.
	 * * Called with (src)
	 * * Timing out also counts.
	 * * Callback should return TRUE to cancel the execution.
	 */
	var/datum/callback/on_non_cooperated
	/**
	 * Called if the receiver cooperates.
	 * * Called with (src)
	 * * Callback should return TRUE to cancel the execution.
	 */
	var/datum/callback/on_cooperated
	/**
	 * Called if target is lost.
	 * * Called with (src)
	 */
	var/datum/callback/on_target_lost

	/**
	 * Did the target cooperate?
	 */
	var/is_cooperative
	/**
	 * How long the target has to give cooperation.
	 */
	var/cooperate_prompt_timeout = 15 SECONDS

#warn impl
