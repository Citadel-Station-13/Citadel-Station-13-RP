//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Common design API for things like lathes to use.
 */
/datum/design_holder

/**
 * * Do not edit passed back list.
 * @return list(design instance = design_context instance, ...)
 */
/datum/design_holder/proc/get_designs_const() as /list
	return list()

/datum/design_holder/proc/has_design(datum/prototype/design/design)
	return design in get_designs_const()

/**
 * @return list(design instance = design_context instance, ...)
 */
/datum/design_holder/proc/get_designs() as /list
	return get_designs_const().Copy()

/**
 * Gets if we have a design context for a given design.
 * @return null if no context exists, or the design isn't in us.
 */
/datum/design_holder/proc/get_design_context(datum/prototype/design/design)
	return null

/**
 * Basic design holder that hard-references its designs.
 */
/datum/design_holder/basic
	/// Designs we contain, associated to contexts
	var/list/datum/prototype/design/designs = list()

/datum/design_holder/basic/Destroy()
	designs.Cut()
	return ..()

/datum/design_holder/basic/proc/add_design(datum/prototype/design/design, datum/design_context/design_context)
	designs[design] = design_context

/datum/design_holder/basic/proc/remove_design(datum/prototype/design/design)
	designs -= design

/datum/design_holder/basic/has_design(datum/prototype/design/design)
	return design in designs

/datum/design_holder/basic/get_design_context(datum/prototype/design/design)
	return designs[design]

/datum/design_holder/basic/get_designs_const()
	return designs
