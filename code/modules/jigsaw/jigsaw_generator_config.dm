//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_generator_config
	/**
	 * Tile budget.
	 * * Overrules [tile_budget_ratio] if set.
	 * * This is ignored for required / priority templates, but they still count against it.
	 */
	var/tile_budget
	/**
	 * Tile budget as a ratio of available tiles.
	 * * This is ignored for required / priority templates, but they still count against it.
	 */
	var/tile_budget_ratio
	/**
	 * Tile budget gaussian center.
	 * * Applied as min() to 'ratio' budget / tile budget if set.
	 */
	var/tile_budget_cap_gaussian_center
	/**
	 * Tile budget gaussian standard deviation.
	 * * Applied as min() to 'ratio' budget / tile budget if set.
	 */
	var/tile_budget_cap_gaussian_stddev
	/**
	 * Custom budgets, key-value list of string-number.
	 * * This list may not be edited by the generator.
	 * * This is ignored for required / priority templates, but they still count against it.
	 */
	var/list/custom_budgets = list()

	/**
	 * Set to override auto-marker settings. Otherwise, this uses
	 * the map's auto-marker config.
	 */
	var/datum/auto_marker_config/auto_marker_config

	/**
	 * Template config
	 */
	var/datum/jigsaw_template_config/template_config

	/**
	 * Spawn configs to use.
	 * * If more than one is specified, one is chosen at random.
	 * * This list may not be edited by the generator.
	 */
	var/list/datum/jigsaw_spawn_config/spawn_configs = list()

/datum/jigsaw_generator_config/clone()
	var/datum/jigsaw_generator_config/clone = new

	clone.tile_budget = src.tile_budget
	clone.tile_budget_ratio = src.tile_budget_ratio
	clone.custom_budgets = src.custom_budgets.Copy()
	clone.auto_marker_config = src.auto_marker_config.clone()
	clone.template_config = src.template_config.clone()
	clone.spawn_configs = deep_clone_list(src.spawn_configs)

	return clone

/datum/jigsaw_generator_config/proc/get_tile_budget(free_tiles)
	. = INFINITY

	if(!isnull(tile_budget))
		. = tile_budget
	else if(!isnull(tile_budget_ratio))
		. = ceil(free_tiles * tile_budget_ratio)

	if(!isnull(tile_budget_cap_gaussian_center) && !isnull(tile_budget_cap_gaussian_stddev))
		var/gaussian_cap = gaussian(tile_budget_cap_gaussian_center, tile_budget_cap_gaussian_stddev)
		. = min(., gaussian_cap)
