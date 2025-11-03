//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Specifically for invoking /datum/emote
 *
 * 'custom emotes' aka 'say'd actions' are not handled by this system.
 */

/**
 * Description WIP
 * * Blocking.
 * * `raw_params` may be a list or a text string.
 * @return TRUE if invoked, FALSE otherwise
 */
/mob/proc/invoke_emote(key, raw_params, datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(actor))
		actor = new(src)
	else if(isnull(actor.performer))
		actor.performer = src
	ASSERT(actor.performer == src)

	var/special_result = process_emote_special(key, raw_params, actor)
	if(!isnull(special_result))
		return special_result

	var/datum/emote/resolved = fetch_emote(key)
	if(!resolved)
		return EMOTE_INVOKE_INVALID
	var/result = process_emote(resolved, raw_params, actor)
	if(result)
		return EMOTE_INVOKE_FINISHED
	else
		return EMOTE_INVOKE_ERRORED

/**
 * Description WIP
 * * `raw_params` may be a list or a text string.
 */
/mob/proc/invoke_emote_async(key, raw_params, datum/event_args/actor/actor)
	set waitfor = FALSE
	. = EMOTE_INVOKE_SLEEPING
	return invoke_emote(key, raw_params, actor)

/**
 * Runs an emote.
 * * Blocking
 * * `raw_params` may be a list or a text string.
 * @return TRUE if successful
 */
/mob/proc/process_emote(datum/emote/emote, raw_params, datum/event_args/actor/actor)
	#warn impl

/**
 * Process special overrides
 * * Blocking
 * * `raw_params` may be a list or a text string.
 * @return EMOTE_INVOKE_* or null if not handled
 */
/mob/proc/process_emote_special(key, raw_params, datum/event_args/actor/actor)
	switch(key)
		if("me")
			if(!length(raw_params))
				actor.chat_feedback(
					SPAN_WARNING("You can't custom emote an empty string!"),
					target = src,
				)
				return EMOTE_INVOKE_ERRORED
			run_custom_emote(raw_params, actor = actor, with_overhead = TRUE)
			return EMOTE_INVOKE_FINISHED
	return null

/**
 * Return a list of /datum/emote's we can **potentially** use
 */
/mob/proc/query_emote()
	RETURN_TYPE(/list)
	. = list()
	var/our_emote_class = get_usable_emote_class()
	for(var/datum/emote/emote as anything in emotes)
		if(!(our_emote_class & emote.emote_class))
			continue
		. += emote

/**
 * Return a list of legacy emotes associated to descriptions or null
 */
/mob/proc/query_emote_special()
	RETURN_TYPE(/list)
	return list(
		"me" = "Input a custom emote for your character to perform.",
	)

/**
 * Return emote classes we support.
 */
/mob/proc/get_usable_emote_class()
	return emote_class

/**
 * Return remote require flags we support
 */
/mob/proc/get_usable_emote_require()
	. = NONE
