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
				stack_trace("collision between [existing.type] and [instance.type] on [binding]")
				break
			GLOB.emote_lookup[binding] = instance

	tim_sort(GLOB.emotes, /proc/cmp_name_asc)

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
	/// * applies to all bindings in bindings list if specified
	var/binding_prefix
	/// parameter help string rendered as "[binding] [parameter_description]"
	var/parameter_description

	/// our emote classes
	/// * A mob must have all of these to use us.
	/// * Missing a class will stop us from appearing in the mob's emote-help panel at all.
	var/emote_class = NONE
	/// our emote require's
	/// * A mob must have all of these to use us.
	/// * Unlike `emote_class`, not having this doesn't exclude the emote from the 'help' list,
	///   as these are assumed to be more temporary.
	var/emote_require = NONE
	/// mobility flags needed to invoke (all of them are if set)
	var/required_mobility_flags = MOBILITY_IS_CONSCIOUS

	/// cannot invoke this again for x time
	var/self_cooldown = 0 SECONDS

/datum/emote/New()
	// preprocess bindings
	if(binding_prefix)
		if(islist(bindings))
			for(var/i in 1 to length(bindings))
				bindings[i] = "[binding_prefix]-[bindings[i]]"
		else
			bindings = "[binding_prefix]-[bindings]"

//* Checks *//

/**
 * Fast check. Emits no errors; can_use() should have all checks in here as this is only used
 * to do the menu check.
 */
/datum/emote/proc/can_potentially_use(datum/event_args/actor/actor, use_emote_class)
	return (emote_class & use_emote_class) == emote_class

/**
 * @params
 * * actor - actor data
 * * arbitrary - arbitrary processed params
 * * out_reasons_fail - out reasons we can't be used right now
 */
/datum/emote/proc/can_use(datum/event_args/actor/actor, list/arbitrary, list/out_reasons_fail)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/special_check = can_use_special(actor, arbitrary, out_reasons_fail)
	if(!isnull(special_check))
		return special_check
	var/their_class = actor.performer.get_usable_emote_class()
	var/their_require = actor.performer.get_usable_emote_require()
	if((their_class & emote_class) != emote_class)
		var/missing_class = emote_class & ~their_class
		if(out_reasons_fail)
			for(var/i in 1 to length(global.emote_class_bit_descriptors))
				if((1<<(i - 1)) & missing_class)
					out_reasons_fail?.Add(global.emote_class_bit_descriptors[i])
		return FALSE
	if((their_require & emote_require) != emote_require)
		var/missing_require = emote_require & ~their_require
		if(out_reasons_fail)
			for(var/i in 1 to length(global.emote_require_bit_descriptors))
				if((1<<(i - 1)) & missing_require)
					out_reasons_fail?.Add(global.emote_require_bit_descriptors[i])
		return FALSE
	return TRUE

/**
 * @params
 * * actor - (optional) the provided actor
 * * arbitrary - (optional) arbitrary processed params
 * * out_reasons_fail - out reasons we can't be used right now
 *
 * @return non-null TRUE / FALSE to override [can_use()]
 */
/datum/emote/proc/can_use_special(datum/event_args/actor/actor, list/arbitrary, list/out_reasons_fail)
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
		loudly_reject_failure("---", actor, silent, "Parameters were too large; skipping emote.")
		return null
	if(!parameter_string)
		return list()
	var/len = length_char(parameter_string)
	var/in_space = TRUE
	var/active_border_char
	var/active_token_pos

	. = list()
	// TODO: faster regex tokenizer?
	for(var/pos in 1 to len)
		var/char = parameter_string[pos]

		var/is_border = FALSE
		var/ignore_one
		switch(char)
			if("\"", "'")
				if(in_space)
					is_border = TRUE
					ignore_one = TRUE
				else if(char == active_border_char)
					is_border = TRUE
					ignore_one = TRUE
				else
					// being inside a token = ignored
					continue
			// no unicode spaces too bad
			if(" ")
				if(in_space)
					// still in space just keep going
					continue
				else
					if(active_border_char)
						// special border char; keep going until finding another
						continue
					else
						// we were in a word and aren't bounded by active border char;
						// this is a border
						is_border = TRUE
						ignore_one = TRUE
			// another character
			else
				// if we're in space and we find a non-special non-space
				// it's the immediate start of a token
				if(in_space)
					is_border = TRUE
					ignore_one = FALSE
		if(is_border)
			// we're at the start or an end of a token
			if(in_space)
				// start token
				in_space = FALSE
				active_token_pos = ignore_one ? pos + 1 : pos
				switch(char)
					if("\"", "'")
						active_border_char = char
			else
				// end token
				var/token = copytext_char(parameter_string, active_token_pos, pos + (ignore_one ? 0 : 1))
				active_border_char = null
				in_space = TRUE
				. += token

	// if we're in a token,
	if(!in_space)
		if(active_border_char)
			// mismatched somewhere
			loudly_reject_failure(parameter_string, actor, silent, "Mismatched '[active_border_char]' in parameters.")
			return null
		else
			// was using space so just insert last
			var/last_token = copytext_char(parameter_string, active_token_pos, len + 1)
			. += last_token

/**
 * Tries to run an emote, if someone's allowed to.
 * * Blocking proc.
 * @params
 * * actor - person doing it
 * * arbitrary - parsed arbitrary params from tokenized parameter string
 * * silent - don't emit errors to actor
 * * used_binding - binding used by user, if any
 */
/datum/emote/proc/try_run_emote(datum/event_args/actor/actor, list/arbitrary, silent, used_binding)
	var/list/why_not = list()
	var/can_run = can_use(actor, arbitrary, why_not)
	if(!can_run)
		if(!silent)
			actor?.chat_feedback(SPAN_WARNING("You can't '[used_binding || name]' right now; ([english_list(why_not, "unknown reason")])"))
		return FALSE
	run_emote(actor, arbitrary, silent, used_binding)
	return TRUE

/**
 * Blocking proc.
 *
 * Runs an emote.
 * * This can still fail if things fail to be parsed from arbitrary list.
 *
 * @params
 * * actor - actor data
 * * arbitrary - arbitrary processed params
 * * silent - suppress errors
 *
 * @return pass / fail
 */
/datum/emote/proc/run_emote(datum/event_args/actor/actor, list/arbitrary, silent, used_binding)
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
