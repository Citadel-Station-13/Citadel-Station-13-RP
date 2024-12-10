//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/prototype/robot_iconset
	abstract_type = /datum/prototype/robot_iconset

	/// icon
	var/icon

	/// base icon state
	var/icon_state
	/// if set, we change our icon state to this from [icon_state] while dead
	/// * this doesn't override base icon state, so things like cover overlays
	///   still apply without change.
	var/dead_state

	/// icon override for primary indicator lighting
	/// * if null, we use base icon.
	var/indicator_icon
	/// primary indicator lighting overlay state
	/// * if null, we do not have primary lighting indicators.
	var/indicator_icon_state

	/// icon override for cover open
	/// * if null, we use base icon.
	var/cover_icon
	/// cover open overlay base state
	///
	/// * if null, we do not have a cover open state.
	/// * ffs this should never be null!
	///
	/// appends:
	/// * "-cell" if cell is in
	/// * "-empty" if cell is out
	/// * "-wires" if wires are exposed
	var/cover_icon_state

#warn impl
