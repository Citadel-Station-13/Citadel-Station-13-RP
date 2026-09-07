//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_generator_results
	/**
	 * Considered failed.
	 * * To ensure nothing was placed, you should still check the other variables.
	 *   Failing to place required templates (Even if some were already placed) is considered a failure.
	 */
	var/failed = FALSE

	var/list/datum/prototype/jigsaw_template/placed_counts = list()

	/**
	 * * this generally only tracks time spent in-algorithm.
	 *   preparing / copying beforehand is unfortunately untracked.
	 */
	var/approximate_ms_used = 0
	var/tile_budget_used = 0
	var/list/custom_budgets_used = list()

/datum/jigsaw_generator_results/serialize()
	. = ..()
	.["failed"] = failed

	var/list/placed_counts_serialized = list()
	for(var/datum/prototype/jigsaw_template/template in placed_counts)
		placed_counts_serialized[template.id] = placed_counts[template]
	.["placed_counts"] = placed_counts_serialized

	.["approximate_ms_used"] = approximate_ms_used
	.["tile_budget_used"] = tile_budget_used
	.["custom_budgets_used"] = custom_budgets_used.Copy()

/datum/jigsaw_generator_results/proc/merge_from(datum/jigsaw_generator_results/other)
	SHOULD_CALL_PARENT(TRUE)

	failed = failed || other.failed

	for(var/datum/prototype/jigsaw_template/template in other.placed_counts)
		placed_counts[template] += other.placed_counts[template]

	approximate_ms_used += other.approximate_ms_used
	tile_budget_used += other.tile_budget_used

	for(var/key in other.custom_budgets_used)
		custom_budgets_used[key] += other.custom_budgets_used[key]
