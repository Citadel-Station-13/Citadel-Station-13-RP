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
	///
	/// with burst weapons, we can start another burst as long as the last burst is finished and fire_delay has elapsed between the start of the last burst.
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
	/// recoil multiplier to be compounded with the gun's
	var/recoil_multiplier = 1
	/// recoil wielded multiplier to be compuonded with the gun's
	var/recoil_wielded_multiplier = 1
	/// special firemode state.
	/// what this does depends on the gun, and the gun has to implement handling for this.
	/// in general:
	///
	/// for append:
	/// this is appended to base_icon_state after gun specific appends, with a - as the separator,
	/// like in an example of "[base_icon_state]-[magazine_state]-[firemode.state-append]-[ammo_count]" for ballistics
	///
	/// for overlay:
	/// the spec is "[base_icon_state]-[state_overlay]" as an overlay
	var/render_state
