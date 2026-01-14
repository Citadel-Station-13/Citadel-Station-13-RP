//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base abstraction for silicon iconsets
 *
 * * Iconsets have no behavior.
 * * This is not considered intrinsic for a robot's behavior, and therefore can be changed without a full state rebuild.
 *
 * todo: please give ids to all of this..
 */
/datum/prototype/robot_iconset
	abstract_type = /datum/prototype/robot_iconset
	anonymous = TRUE
	anonymous_namespace = "robot_iconset"

	/// the name of this iconset
	var/name
	/// the display name of this iconset
	/// * this is player facing!
	/// * defaults to [name]
	var/display_name

	/// the path, id, or instance of robot chassis we are supposed to be
	/// * this is not enforced, this is used for auto-gen
	var/auto_chassis

	/// icon
	var/icon

	/// base icon state
	var/icon_state
	/// primary indicator lighting overlay state
	/// * if null, we do not have primary lighting indicators.
	var/icon_state_indicator
	/// cover open overlay base state
	///
	/// * if null, we do not have a cover open state.
	/// * ffs this should never be null!
	///
	/// appends:
	/// * "-cell" if cell is in
	/// * "-empty" if cell is out
	/// * "-wires" if wires are exposed
	var/icon_state_cover

	/// Icon width
	var/icon_dimension_x = 32
	/// Icon height
	var/icon_dimension_y = 32

	/// indicator lighting colorable?
	/// * for now, only supports NONE and MULTIPLY
	var/indicator_lighting_coloration_mode = COLORATION_MODE_NONE
	/// indicator lighting packed coloration
	/// * for now, only supports a single RRGGBB(AA) string.
	var/indicator_lighting_coloration_packed = "#ffffff"

	/// variations
	/// * this is a list of typepaths / anonymous types at compile time, and
	///   turned into an id-instance lookup map at init.
	///
	/// special ones:
	/// * /datum/robot_iconset_variation/dead
	/// * /datum/robot_iconset_variation/resting
	/// * /datum/robot_iconset_variation/sitting
	/// * /datum/robot_iconset_variation/bellyup
	var/list/variations

/datum/prototype/robot_iconset/New()
	..()
	for(var/i in 1 to length(variations))
		var/datum/robot_iconset_variation/maybe_variation = variations[i]
		if(ispath(maybe_variation))
			maybe_variation = new maybe_variation
		else if(IS_ANONYMOUS_TYPEPATH(maybe_variation))
			maybe_variation = new maybe_variation
		else if(istype(maybe_variation))
		else
			stack_trace("invalid variation in index [i] on [type] ([id])")
		variations[maybe_variation.id] = maybe_variation

/datum/prototype/robot_iconset/proc/get_display_name()
	return display_name || name
