//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A configurable airlock program.
 */
/datum/airlock_program
	/// tgui routing string used to get the right component
	var/tgui_airlock_component
	/// the cycle state type to create & use
	var/airlock_cycle_type = /datum/airlock_cycle

#warn base tgui
