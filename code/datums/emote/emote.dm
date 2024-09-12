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

/**
 * Emotes!
 *
 * * Custom /me emotes are not part of this. They're way too weird / expressive.
 */
/datum/emote
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

/**
 * Paired with /mob/proc/filter_usable_emotes()!
 *
 * @params
 * * actor - actor data
 * * arbitrary - arbitrary processed params
 */
/datum/emote/proc/can_use(datum/event_args/actor/actor, list/arbitrary, check_mobility)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/special_check = can_use_special(actor)
	if(!isnull(special_check))
		return special_check

	if(check_mobility && !(actor.performer.mobility_flags & required_mobility_flags))
		return FALSE
	if(!(actor.performer.get_usable_emote_class() & emote_class))
		return FALSE
	if(!(actor.performer.get_usable_emote_require() & emote_require))
		return FALSE
	return TRUE

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
 * @return the 'arbitrary' param passed into the rest of the emote call chain
 */
/datum/emote/proc/process_parameters(datum/event_args/actor/actor, parameter_string)
	return list(EMOTE_PARAMETER_KEY_ORIGINAL = parameter_string)

/**
 * Blocking proc.
 *
 * Tries to run an emote, if someone's allowed to.
 */
/datum/emote/proc/try_run_emote(datum/event_args/actor/actor, list/arbitrary)
	#warn impl

/**
 * Blocking proc.
 *
 * Runs an emote.
 *
 * @params
 * * actor - actor data
 * * arbitrary - arbitrary processed params
 */
/datum/emote/proc/run_emote(datum/event_args/actor/actor, list/arbitrary)
	#warn impl
