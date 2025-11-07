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
 * @return TRUE if invoked, FALSE otherwise
 */
/mob/proc/invoke_emote(key, parameter_string, datum/event_args/actor/actor)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(actor))
		actor = new(src)
	ASSERT(actor.performer == src)

	// always apply anti-spam
	if(HAS_TRAIT(src, TRAIT_EMOTE_GLOBAL_COOLDOWN))
		return EMOTE_INVOKE_ERRORED
	ADD_TRAIT(src, TRAIT_EMOTE_GLOBAL_COOLDOWN, "__EMOTE__")
	REMOVE_TRAIT_IN(src, TRAIT_EMOTE_GLOBAL_COOLDOWN, "__EMOTE__", 0.25 SECONDS)

	var/special_result = process_emote_special(key, parameter_string, actor)
	if(!isnull(special_result))
		return special_result

	var/datum/emote/resolved = fetch_emote(key)
	if(!resolved)
		return EMOTE_INVOKE_INVALID
	if(HAS_TRAIT(src, TRAIT_EMOTE_COOLDOWN(resolved.type)))
		return EMOTE_INVOKE_ERRORED
	var/result = process_emote(resolved, parameter_string, actor, used_binding = key)
	if(result)
		return EMOTE_INVOKE_FINISHED
	else
		return EMOTE_INVOKE_ERRORED

/**
 * Description WIP
 */
/mob/proc/invoke_emote_async(key, parameter_string, datum/event_args/actor/actor)
	set waitfor = FALSE
	. = EMOTE_INVOKE_SLEEPING
	return invoke_emote(key, parameter_string, actor)

/**
 * Runs an emote.
 * * Blocking
 * * `raw_params` may be a list or a text string.
 * @return TRUE if successful
 */
/mob/proc/process_emote(datum/emote/emote, parameter_string, datum/event_args/actor/actor, used_binding)
	var/list/arbitrary = emote.process_parameters(parameter_string, actor)
	// only continue if parameter parsing worked
	if(arbitrary == null)
		return
	// apply specific emote cooldown but only after it's done executing; checked in invoke_emote()
	ADD_TRAIT(src, TRAIT_EMOTE_COOLDOWN(emote.type), "__EMOTE__")
	. = emote.try_run_emote(actor, arbitrary, used_binding = used_binding)
	REMOVE_TRAIT_IN(src, TRAIT_EMOTE_COOLDOWN(emote.type), "__EMOTE__", emote.self_cooldown)

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
		if("help")
			var/list/datum/emote/can_run_emotes = query_emote()
			var/list/assembled_html = list()
			for(var/datum/emote/emote as anything in can_run_emotes)
				if((islist(emote.bindings) && !length(emote.bindings)) || !emote.bindings)
					continue
				var/rendered_bindings = islist(emote.bindings) ? jointext(emote.bindings, "/") : emote.bindings
				var/rendered_first_binding = islist(emote.bindings) ? emote.bindings[1] : emote.bindings
				assembled_html += SPAN_TOOLTIP_DANGEROUS_HTML("[rendered_bindings][emote.parameter_description ? " [emote.parameter_description]" : ""]", rendered_first_binding)
			to_chat(src, "Usable emotes: [english_list(assembled_html)]")
			// TODO: should be FINISHED but we need to route to legacy *help too!
			return null
	return null

/**
 * Return a list of /datum/emote's we can **potentially** use
 */
/mob/proc/query_emote()
	RETURN_TYPE(/list)
	. = list()
	var/our_emote_class = get_usable_emote_class()
	var/datum/event_args/actor/actor = new(src)
	for(var/datum/emote/emote as anything in GLOB.emotes)
		if(!emote.can_potentially_use(actor, our_emote_class))
			continue
		. += emote

/**
 * Return a list of legacy emotes associated to descriptions or null
 */
/mob/proc/query_emote_special()
	RETURN_TYPE(/list)
	return list(
		"me" = "Input a custom emote for your character to perform.",
		"help" = "Get a list of usable emotes.",
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
