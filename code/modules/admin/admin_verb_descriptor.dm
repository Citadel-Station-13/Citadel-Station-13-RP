//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_REAL_PROTECT(admin_verbs)
GLOBAL_REAL_LIST(admin_verb_descriptors) = zz__prepare_admin_verb_descriptors()

/proc/zz__prepare_admin_verb_descriptors()
	. = list()
	for(var/datum/admin_verb_descriptor/path as anything in subtypesof(/datum/admin_verb_descriptor))
		. += new path

/**
 * Describes an admin verb.
 *
 * When admin verbs should be used:
 * * Core debug functions (VV, SDQL, similar). These should **never** be abstracted to complex
 *   systems like TGUI, as we need thse to debug said complex systems!
 * * Anything that invokes on right click
 * * Anything that is very simple to invoke ('spawn') and is used enough that removing it
 *   for a panel makes no sense as it would make the lives of people using the in-game
 *   command line worse!
 */
/datum/admin_verb_descriptor
	/// our unique ID; this is based on verb path!
	var/id
	/// our verb path
	var/verb_path
	/// the reflection path to read from
	var/reflection_path
	/// required rights flags
	var/required_rights

	//* detected from verb *//

	/// our name
	var/name
	/// our desc
	var/desc

/datum/admin_verb_descriptor/New()
	if(!verb_path)
		return
	var/procpath/cast_verb = reflection_path
	name = cast_verb.name
	desc = cast_verb.desc
