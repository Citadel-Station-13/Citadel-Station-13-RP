//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Holds metabolism state on reagents.
 */
/datum/reagent_metabolism
	/// arbitrary blackboard for metabolism
	///
	/// * This is separate from data because a lot of things require this and data is far more expensive.
	var/list/blackboard = list()

	/// maximum amount ever put in
	var/peak_dose = 0
	/// maximum amount processed so far
	var/total_processed_dose = 0

	/// cycles we've been in a mob
	var/cycles_so_far = 0
	/// cycles we've been overdosing
	///
	/// * This is reset if we stop overdosing, even for a single tick.
	var/cycles_overdosing = 0

	//! LEGACY LOOKUP VARIABLES !//
	/// set to volume remaining
	var/legacy_volume_remaining
	/// set to data
	var/legacy_data
	/// the reagent holder we're in
	var/datum/reagent_holder/legacy_current_holder
