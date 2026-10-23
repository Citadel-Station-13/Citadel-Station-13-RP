//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Runs multiple generator cycles on a buffer.
 */
/datum/jigsaw_chain_generator_config
	var/prepared = FALSE

	/**
	 * Tile budget.
	 * * Overrules [tile_budget_ratio] if set.
	 * * This is ignored for required / priority templates, but they still count against it.
	 * * This is applied in parallel to the jigsaw generator config's limits.
	 */
	var/tile_budget
	/**
	 * Tile budget as a ratio of available tiles.
	 * * This is ignored for required / priority templates, but they still count against it.
	 * * This is applied in parallel to the jigsaw generator config's limits.
	 */
	var/tile_budget_ratio
	/**
	 * Tile budget gaussian center.
	 * * Applied as min() to 'ratio' budget / tile budget if set.
	 * * This is applied in parallel to the jigsaw generator config's limits.
	 */
	var/tile_budget_cap_gaussian_center
	/**
	 * Tile budget gaussian standard deviation.
	 * * Applied as min() to 'ratio' budget / tile budget if set.
	 * * This is applied in parallel to the jigsaw generator config's limits.
	 */
	var/tile_budget_cap_gaussian_stddev
	/**
	 * Tile budget gaussian center.
	 * * Applied as min() to 'ratio' budget / tile budget if set.
	 * * This is applied in parallel to the jigsaw generator config's limits.
	 */
	var/tile_budget_cap_ratio_gaussian_center
	/**
	 * Tile budget gaussian standard deviation.
	 * * Applied as min() to 'ratio' budget / tile budget if set.
	 * * This is applied in parallel to the jigsaw generator config's limits.
	 */
	var/tile_budget_cap_ratio_gaussian_stddev
	/**
	 * Custom budgets, key-value list of string-number.
	 * * This list may not be edited by the generator.
	 * * This is ignored for required / priority templates, but they still count against it.
	 * * This is applied in parallel to the jigsaw generator config's limits.
	 */
	var/list/custom_budgets = list()

/datum/jigsaw_chain_generator_config/proc/get_resultant_config() as /datum/jigsaw_chain_generator_resultant_config
	SHOULD_CALL_PARENT(TRUE)

	var/datum/jigsaw_chain_generator_resultant_config/result = new

	result.tile_budget = src.tile_budget
	result.tile_budget_ratio = src.tile_budget_ratio
	result.tile_budget_cap_gaussian_center = src.tile_budget_cap_gaussian_center
	result.tile_budget_cap_gaussian_stddev = src.tile_budget_cap_gaussian_stddev
	result.tile_budget_cap_ratio_gaussian_center = src.tile_budget_cap_ratio_gaussian_center
	result.tile_budget_cap_ratio_gaussian_stddev = src.tile_budget_cap_ratio_gaussian_stddev
	result.custom_budgets = src.custom_budgets.Copy()

	return result

/datum/jigsaw_chain_generator_config/weighted_pick
	/**
	 * A list of generator config-literals to use.
	 * * Associate to number for weight. None = 1 weight.
	 */
	var/list/datum/jigsaw_generator_config/configs = list()

	/**
	 * A list of resolvables for presets to use.
	 * * Associate to number for weight. None = 1 weight.
	 */
	var/list/datum/prototype/jigsaw_generator_preset/presets = list()

/datum/jigsaw_chain_generator_config/weighted_pick/get_resultant_config()
	var/datum/jigsaw_chain_generator_resultant_config/result = ..()

	result.weighted_configs = configs.Copy()

	for(var/key in presets)
		var/datum/prototype/jigsaw_generator_preset/preset = RSjigsaw_generator_presets.fetch_local_or_throw(key)
		var/datum/jigsaw_generator_config/config = preset.get_config()
		result.weighted_configs[config] += presets[key]

	return result

/datum/jigsaw_chain_generator_config/literally_everything

/datum/jigsaw_chain_generator_config/literally_everything/get_resultant_config()
	var/datum/jigsaw_chain_generator_resultant_config/result = ..()

	for(var/datum/prototype/jigsaw_generator_preset/preset as anything in RSjigsaw_generator_presets.fetch_subtypes_immutable(/datum/prototype/jigsaw_generator_preset))
		var/datum/jigsaw_generator_config/config = preset.get_config()
		result.weighted_configs[config] = 1

	return result
