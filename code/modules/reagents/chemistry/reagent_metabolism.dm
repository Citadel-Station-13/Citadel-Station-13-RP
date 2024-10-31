//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Holds metabolism state on reagents.
 */
/datum/reagent_metabolism
	/// maximum amount ever put in
	var/peak_dose = 0
	/// cycles we've been in a mob
	var/cycles_so_far = 0
	/// cycles we've been overdosing
	var/cycles_overdosing = 0

#warn impl
