//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_chain_generator_results
	var/list/datum/jigsaw_generator_results/results = list()

	var/tmp/total_approximate_ms_used = 0
	var/tmp/total_tile_budget_used = 0
	var/tmp/list/total_custom_budgets_used = list()

#warn impl
