//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Runs multiple generator cycles on a buffer.
 */
/datum/jigsaw_chain_generator
	var/datum/jigsaw_chain_generator_config/config

/datum/jigsaw_chain_generator/New(datum/jigsaw_chain_generator_config/config)
	src.config = config

/datum/jigsaw_chain_generator/proc/generate(datum/jigsaw_buffer/buffer)
	var/datum/jigsaw_chain_generator_results/results = new
	var/datum/jigsaw_chain_generator_resultant_config/resultant_config = config.get_resultant_config()

	var/tile_budget_left = resultant_config.get_tile_budget(buffer.get_empty_tile_count())

	if(tile_budget_left <= 0)
		return results

	var/list/custom_budgets_left = resultant_config.custom_budgets.Copy()

	var/iteration_limit = 100

	// owned ref, may modify
	var/list/push_configs = resultant_config.explicit_configs.Copy()
	// borrowed ref, do not modify
	var/list/weighted_configs = resultant_config.weighted_configs

	do
		iteration_limit--

		var/datum/jigsaw_generator_config/use_config

		for(var/key in push_configs)
			if(push_configs[key] <= 0)
				push_configs -= key

		if(length(push_configs))
			var/datum/jigsaw_generator_config/config = pick(push_configs)

			push_configs[config] -= 1
			if(push_configs[config] <= 0)
				push_configs -= config

			use_config = config
		else
			use_config = pickweight(weighted_configs)

		if(!use_config)
			break

		var/datum/jigsaw_generator_config/modified_config = use_config.clone()
		modified_config.tile_budget = tile_budget_left
		modified_config.custom_budgets = custom_budgets_left

		var/datum/jigsaw_generator/generator = new(modified_config)
		var/datum/jigsaw_generator_results/generator_results = generator.generate(buffer)

		results.results += generator_results
		results.total_approximate_ms_used += generator_results.approximate_ms_used
		results.total_tile_budget_used += generator_results.tile_budget_used
		for(var/key in generator_results.custom_budgets_used)
			results.total_custom_budgets_used[key] += generator_results.custom_budgets_used[key]
			custom_budgets_left[key] -= generator_results.custom_budgets_used[key]

		tile_budget_left -= generator_results.tile_budget_used

	while(tile_budget_left > 0 && iteration_limit > 0)

	return results
