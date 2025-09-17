//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base metrics recorded every round.
 *
 * This includes things required to display metrics data, like round ID,
 * server revision, and more.
 *
 * Any of these may be missing if we're unable to get the data. If round ID is
 * missing, we should just bail on metrics reporting, as round ID is an
 * identifying key in the metrics database.
 *
 * * Testmerges are intentionally not included as part of this. No metrics render solution
 *   should be performing full testmerges in general; testmerge data can always
 *   be recorded as a series data.
 */
/datum/metric_base
	/// round ID as **string**
	var/round_id
	/// server revision hash
	///
	/// * dependent on git; at time of writing this is SHA-1
	var/commit_hash
	/// all valid metric ids, as a list
	///
	/// * this is generated via typesof()
	var/list/metric_ids
