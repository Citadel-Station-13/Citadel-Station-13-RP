//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base abstraction for silicon iconsets
 *
 * * Iconsets have no behavior.
 */
/datum/prototype/robot_iconset
	abstract_type = /datum/prototype/robot_iconset

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
	#warn hook
	var/icon_dimension_x = 32
	/// Icon height
	#warn hook
	var/icon_dimension_y = 32
	/// x axis shift to the borg's sprite
	#warn hook
	var/base_pixel_x = 0

	// todo: coloration system;
	//       using greyscale sprites would be nice.

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


#warn impl
#warn resolve variations
