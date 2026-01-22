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
	 * Arbitrary blackboard list.
	 */
	var/list/blackboard = list()
	/**
	 * Mindnet initiating this execution
	 */
	var/datum/stargazer_mindnet/mindnet
	/**
	 * Initiating actor.
	 * * This doesn't necessarily match the mindnet's owner.
	 */
	var/datum/event_args/actor/actor

	/**
	 * Target mind, if any.
	 * * Nullable
	 */
	var/datum/mind/target_mind
	/**
	 * Called to check if target is still valid
	 * * Nullable
	 * * Called with (src)
	 */
	var/datum/callback/on_target_valid

	/**
	 * Called with any unhandled Topic()
	 * * Nullable
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
	/**
	 * Is our prompt already done?
	 */
	var/is_prompt_finished = FALSE

	/**
	 * How long to not delete after being done
	 */
	var/keep_alive_for
	/**
	 * Delete-self timerid after finishing
	 */
	var/cleanup_timerid

/datum/stargazer_mindnet_exec/New(datum/stargazer_mindnet/mindnet, dedupe_key)
	#warn mindnet
	src.dedupe_key = dedupe_key || num2text(rand(1, 999999), 16)

/**
 * * Passed in link should have a `%%COOPERATE%%` inside it which will be
 *   replaced with the cooperate link in chat.
 */
/datum/stargazer_mindnet_exec/proc/set_chat_prompt(format)

/datum/stargazer_mindnet_exec/proc/run_prompt()

/**
 * Keeps us alive for atleast this much more time.
 * * Used to stop an exec from being qdel'd even after the cooperation prompt is done.
 * * Will **overwrite** a prior 'keep alive for', potentially resulting in us being deleted **sooner**.
 */
/datum/stargazer_mindnet_exec/proc/keep_alive_for(time)
	keep_alive_for = time
	if(is_prompt_finished)
		kick_cleanup_timer()

/datum/stargazer_mindnet_exec/proc/kick_cleanup_timer()
	if(cleanup_timerid)
		deltimer(cleanup_timerid)
	cleanup_timerid = addtimer(CALLBACK(src, PROC_REF(cleanup)), keep_alive_for, TIMER_STOPPABLE)

/datum/stargazer_mindnet_exec/proc/cleanup()


#warn impl
