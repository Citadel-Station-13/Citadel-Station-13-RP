//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Gun firing modes
 *
 * Handles a bunch of things, like overriding firing sounds, burst amounts, etc.
 */
/datum/firemode
	/// player-facing name - this is rendered as '[gun] is now firing in [name] mode.'
	var/name = "an unknown"
	/// shots in burst
	var/burst_amount = 1
	/// burst spacing in deciseconds
	var/burst_spacing = 0.5
	/// override fire delay after shooting before the gun can be shot again
	/// this overrides clickdelay!
	var/fire_delay
	/// override fire sound
	/// priority:
	/// projectile fire sound --> firemode fire sound --> gun fire sound
	var/fire_sound
	/// state mode append, if any
	var/state_append
	/// our mode radial icon
	var/radial_icon
	/// our mode radial state
	var/radial_state
	/// sound played when someone switches to this firemode
	var/select_sound = 'sound/weapons/guns/selector.ogg'

	//! legacy modifystate
	var/legacy_modifystate

