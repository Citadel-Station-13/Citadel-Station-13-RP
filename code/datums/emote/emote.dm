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
		#warn impl

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

	/// our emote classes
	var/emote_class = EMOTE_CLASS_DEFAULT
	/// our emote require's
	var/emote_require = NONE
	/// mobility flags needed to invoke (all of them are if set)
	var/required_mobility_flags = MOBILITY_IS_CONSCIOUS

#warn impl

//* Checks *//

/**
 * @params
 * * actor - actor data
 * * arbitrary - arbitrary processed params
 */
/datum/emote/proc/can_use(datum/event_args/actor/actor, arbitrary)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/special_check = can_use_special(actor)
	if(!isnull(special_check))
		return special_check

	#warn impl

/**
 * @return non-null TRUE / FALSE to override [can_use()]
 */
/datum/emote/proc/can_use_special(datum/event_args/actor/actor, arbitrary)
	return

//* Execution *//

/**
 * Process passed in string (so anything after a **single** space from the emote key) to an 'arbitrary',
 * which is just how we process params
 *
 * @return the 'arbitrary' param passed into the rest of the emote call chain
 */
/datum/emote/proc/process_parameters(datum/event_args/actor/actor, parameter_string)
	return parameter_string

/**
 * Blocking proc.
 *
 * Tries to run an emote, if someone's allowed to.
 */
/datum/emote/proc/try_run_emote(datum/event_args/actor/actor, arbitrary)
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
/datum/emote/proc/run_emote(datum/event_args/actor/actor, arbitrary)
	#warn impl
