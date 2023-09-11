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
	/// our mode radial icon
	var/radial_icon
	/// our mode radial state
	var/radial_state
	/// sound played when someone switches to this firemode
	var/select_sound = 'sound/weapons/guns/selector.ogg'
	/// recoil multiplier
	var/recoil_multiplier = 1
	/// special firemode state.
	/// what this does depends on the gun, and the gun has to implement handling for this.
	/// in general:
	///
	/// for append:
	/// this is appended to base_icon_state before gun specific appends, with a - as the separator,
	/// like in an example of "[base_icon_state]-[firemode.state-append]-[magazine_state]-[ammo_count]" for ballistics
	///
	/// for overlay:
	/// the spec is "[base_icon_state]-[state_overlay]" as an overlay
	var/render_state

	//! legacy modifystate
	var/legacy_modifystate

