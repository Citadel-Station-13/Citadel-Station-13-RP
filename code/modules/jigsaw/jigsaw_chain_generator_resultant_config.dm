//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_chain_generator_resultant_config
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

	/**
	 * A list of generator configs to try to emplace
	 * * The list itself may be modified, but not its elements.
	 */
	var/list/datum/jigsaw_generator_config/explicit_configs = list()

	/**
	 * A list of generator config-literals to use until out of budget or time expired.
	 * * Associate to number for weight. None = 1 weight.
	 * * The list itself may be modified, but not its elements.
	 */
	var/list/datum/jigsaw_generator_config/weighted_configs = list()

/datum/jigsaw_chain_generator_resultant_config/Destroy()
	explicit_configs = null
	weighted_configs = null
	return ..()

/datum/jigsaw_chain_generator_resultant_config/proc/get_tile_budget(free_tiles)
	. = INFINITY

	if(!isnull(tile_budget))
		. = tile_budget
	else if(!isnull(tile_budget_ratio))
		. = ceil(free_tiles * tile_budget_ratio)

	if(!isnull(tile_budget_cap_gaussian_center) && !isnull(tile_budget_cap_gaussian_stddev))
		var/gaussian_cap = gaussian(tile_budget_cap_gaussian_center, tile_budget_cap_gaussian_stddev)
		. = min(., gaussian_cap)

	if(!isnull(tile_budget_cap_ratio_gaussian_center) && !isnull(tile_budget_cap_ratio_gaussian_stddev))
		var/gaussian_cap = gaussian(tile_budget_cap_ratio_gaussian_center, tile_budget_cap_ratio_gaussian_stddev)
		. = min(., ceil(free_tiles * gaussian_cap))
