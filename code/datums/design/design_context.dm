//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Since designs are immutable prototypes, it's very difficult to do state
 * tracking like limited prints with them.
 *
 * Instead, we pass context datums with designs to have exactly this work;
 * state and custom behavior goes on context.
 */
/datum/design_context
	/// run 'get_prints_left'
	var/implements_has_prints_left = FALSE

	/// hard-block copying this design
	var/drm_protected = FALSE

	/// if exists, run on **lathe** print with
	/// (lathe, created, material_parts, ingredient_parts, reagent_parts, cost_multiplier)
	var/datum/callback/on_lathe_print

	// TODO: trace data for where the design comes from, e.g. 'server xyz in research network'

/**
 * @return string
 */
/datum/design_context/proc/get_prints_left_str()
	return "-- error --"

/**
 * @return number
 */
/datum/design_context/proc/get_prints_left_num()
	return INFINITY

/**
 * Lazy implementation that lets you do things like 'has prints left', etc
 */
/datum/design_context/lazy_impl
	/// if you use this, turn `implements_has_prints_left` to `TRUE
	var/ctx_prints_left = 0

/datum/design_context/lazy_impl/get_prints_left_str()
	return "AMT: [ctx_prints_left]"

/datum/design_context/lazy_impl/get_prints_left_num()
	return ctx_prints_left
