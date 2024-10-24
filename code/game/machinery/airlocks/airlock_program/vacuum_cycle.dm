//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Default airlock program; just cycles the airlock to 0 and then goes back up.
 *
 * * Quite a dumb program. More of a proof of concept.
 * * Exterior air will always be vented to and drawn from exterior.
 * * Interior air will always be drawn from the airlock's handler, and can be vented to exterior
 *   or sent through scrubber layer of handler as needed.
 * * Environment config will only be checked for pressure and nothing else.
 */
/datum/airlock_program/vacuum_cycle
	tgui_airlock_component = "VacuumCycle"
	airlock_cycle_type = /datum/airlock_cycle/vacuum_cycle

	/// allow venting gas out external
	///
	/// * this, if set, allows gas to be 'lost'!
	/// * this, if set, will make gas go out external if it takes
	///   less power to do so than interior.
	var/allow_vent = FALSE
	/// always vent gas out external
	///
	/// * this, if set, allows gas to be 'lost'!
	/// * this, if set, will always vent gas out to external.
	var/always_vent = FALSE

#warn impl

#warn tgui
