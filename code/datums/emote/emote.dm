//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// init'd by early init
GLOBAL_LIST(emotes)
// init'd by early init
GLOBAL_LIST(emote_lookup)

/proc/init_emote_meta()
	GLOB.emotes = list()
	GLOB.emote_lookup = list()

	for(var/datum/emote/path as anything in subtypesof(/datum/emote))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/emote/instance = new path
		GLOB.emotes += instance

		for(var/binding in islist(instance.bindings) ? instance.bindings : list(instance.bindings))
			if(GLOB.emote_lookup[binding])
				var/datum/emote/existing = GLOB.emote_lookup[binding]
				stack_trace("collision between [existing.type] and [type] on [binding]")
				break
			GLOB.emote_lookup[binding] = instance

/proc/fetch_emote(key) as /datum/emote
	return GLOB.emote_lookup[key]

/**
 * Emotes!
 *
 * * Custom /me emotes are not part of this. They're way too weird / expressive.
 */
/datum/emote
	abstract_type = /datum/emote

	/// emote name
	var/name = "Unnamed Emote (Yell at Coders)"
	/// emote desc, if any
	var/desc = "An action you can perform with your character. Yell at coders to set descriptions if you see this."
	/// our bindings key(s)
	///
	/// * can be a string or a list
	/// * if a list, the first string in the list is the primary; rest are alises
	/// * for now, emote bindings must be unique to a single emote. in the future, this may change.
	var/bindings
	/// a prefix to use before our binding
	var/binding_prefix
	/// parameter help string rendered as "[binding] [parameter_description]"
	var/parameter_description

	/// our emote classes
	var/emote_class = EMOTE_CLASS_DEFAULT
	/// our emote require's
	var/emote_require = NONE
	/// mobility flags needed to invoke (all of them are if set)
	var/required_mobility_flags = MOBILITY_IS_CONSCIOUS

#warn impl

/datum/emote/New()
	// preprocess bindings
	if(binding_prefix)
		if(islist(bindings))
			for(var/i in 1 to length(bindings))
				bindings[i] = "[binding_prefix]-[bindings[i]]"
		else
			bindings = "[binding_prefix]-[bindings]"

//* Checks *//

#warn refactor this shit okay
/**
 * Paired with /mob/proc/filter_usable_emotes()!
 *
 * @params
 * * actor - actor data
 * * arbitrary - arbitrary processed params
 * * only_validity - only check if we're even a valid emote, ignore mobility/require/etc
 */
/datum/emote/proc/can_use(datum/event_args/actor/actor, list/arbitrary, only_validity)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/special_check = can_use_special(actor)
	if(!isnull(special_check))
		return special_check

	if(!only_validity && !can_potentially_use())
	if(only_validity && !((actor.performer.mobility_flags & required_mobility_flags) == required_mobility_flags))
		return FALSE
	if(!(actor.performer.get_usable_emote_class() & emote_class))
		return FALSE
	if(only_validity && !((actor.performer.get_usable_emote_require() & emote_require) == emote_require))
		return FALSE
	return TRUE

/datum/emote/proc/can_potentially_use(datum/event_args/actor/actor, use_classes, use_requires)
	if(isnull(use_classes))
	if(isnull(use_requires))
	#warn impl


/**
 * @params
 * * actor - (optional) the provided actor
 * * arbitrary - (optional) arbitrary processed params
 *
 * @return non-null TRUE / FALSE to override [can_use()]
 */
/datum/emote/proc/can_use_special(datum/event_args/actor/actor, list/arbitrary)
	return

//* Execution *//

/**
 * Process passed in string (so anything after a **single** space from the emote key) to an 'arbitrary',
 * which is just how we process params
 *
 * @return the 'arbitrary' param passed into the rest of the emote call chain, null on fail
 */
/datum/emote/proc/process_parameters(parameter_string, datum/event_args/actor/actor, silent)
	return list(EMOTE_PARAMETER_KEY_ORIGINAL = parameter_string)

/**
 * Standard parameter tokenization. Allows double-quoting, single-quoting, and just space-ing
 * @return list, or null on fail
 */
/datum/emote/proc/tokenize_parameters(parameter_string, datum/event_args/actor/actor, silent)
	// incase they try something fishy
	// notice the length(); curse of RA can be a problem.
	if(length(parameter_string) >= MAX_MESSAGE_LEN)
		return null
	var/len = length_char(parameter_string)
	var/pos = 0
	var/in_space = TRUE
	var/active_border_char
	var/active_border_pos

	. = list()
	for(var/char in parameter_string)
		++pos

		var/is_border = FALSE
		switch(char)
			if("\"", "'")
				if(!active_border)
					is_border = TRUE
				else if(char == active_border_char)
					is_border = TRUE
			// no unicode spaces too bad
			if(" ")
				if(in_space)
					// still in space just keep going
					continue
				else
					if(active_border_char)
						// special border char; keep going until finding another
					else
						// we were in a word and aren't bounded by active border;
						// this is a border
						is_border = TRUE
		if(is_border)
			// we're at the start or an end of a token
			if(in_space)
				// start token
				active_border_pos = pos
				if(char != " ")
					active_border_char = char
			else
				// end token
				var/token = copytext_char(parameter_string, active_border_char + 1, pos)
				active_border_char = null
				. += token

	// if we're in a token,
	if(!in_space)
		if(active_border_char)
			// mismatched somewhere
			loudly_reject_failure(parameter_string, actor, silent, "Mismatched '[active_border_char]' in parameters.")
			return null
		else
			// was using space so just insert last
			var/last_token = copytext_char(parameter_string, active_border_char + 1, len + 1)
			. += last_token

/**
 * Blocking proc.
 *
 * Tries to run an emote, if someone's allowed to.
 */
/datum/emote/proc/try_run_emote(datum/event_args/actor/actor, list/arbitrary)
	#warn impl
	#warn tokenize

/**
 * Blocking proc.
 *
 * Runs an emote.
 * * This can still fail if things fail to be parsed from arbitrary list.
 *
 * @params
 * * actor - actor data
 * * arbitrary - arbitrary processed params
 *
 * @return pass / fail
 */
/datum/emote/proc/run_emote(datum/event_args/actor/actor, list/arbitrary)
	return TRUE

/datum/emote/proc/get_mob_context(mob/invoking)
	return invoking.emotes_running?[src]

/datum/emote/proc/set_mob_context(mob/invoking, ctx)
	if(!invoking.emotes_running)
		invoking.emotes_running = list()
	invoking.emotes_running[src] = ctx

/datum/emote/proc/loudly_reject_failure(parameter_string, datum/event_args/actor/actor, silent, reason)
	if(!silent)
		actor?.chat_feedback(
			SPAN_WARNING("Failed emote parse on {[parameter_string]} - [reason]"),
		)
