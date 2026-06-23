//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_generator_config
	var/tile_budget = 0
	var/list/custom_budgets = list()

	/**
	 * Set to override auto-marker settings. Otherwise, this uses
	 * the map's auto-marker config.
	 */
	var/datum/turf_auto_marker_config/auto_marker_config

/datum/jigsaw_spawn_resultant_config

/datum/jigsaw_spawn_config

/datum/jigsaw_spawn_config/proc/get_resultant_config() as /datum/jigsaw_spawn_resultant_config
	return new /datum/jigsaw_spawn_resultant_config

/datum/jigsaw_spawn_config/specific

/datum/jigsaw_spawn_config/specific/get_resultant_config()
	var/datum/jigsaw_spawn_resultant_config/result = new

	return result

/datum/jigsaw_template_resultant_config
	/// alignment
	/// * this is minimum dimensions (width and height); width and height of
	///   all templates must be in alignment multiples plus one tile of border in each side
	var/alignment = 8

	/// always start with these templates, if exists
	/// * may be typepaths or instances
	/// * this ignores budget and will not take from it.
	var/list/datum/jigsaw_template/initial_templates = list()
	/// ***attempt*** to place these templates, associate to count
	/// * this ignores budget and will not take from it.
	var/list/datum/jigsaw_template/priority_templates = list()
	/// require placement of these templates, associate to count
	/// * if any of these fail to place, the generation fails
	/// * this ignores budget and will not take from it.
	var/list/datum/jigsaw_template/required_templates = list()

	/// templates to use, weighted.
	/// * may be typepaths or instances
	/// * this are constrained by budgets.
	var/list/datum/jigsaw_template/weighted_templates = list()

	/// allowed costs
	/// * only used for weighted templates
	var/list/budgets = list()

/datum/jigsaw_template_config

/datum/jigsaw_template_config/proc/get_resultant_config() as /datum/jigsaw_template_resultant_config
	return new /datum/jigsaw_template_resultant_config

/datum/jigsaw_template_config/everything
	/// allowed costs
	var/list/budgets = list()

/datum/jigsaw_template_config/everything/get_resultant_config()
	var/datum/jigsaw_template_resultant_config/result = new
	results.budgets = budgets.Copy()
	for(var/datum/jigsaw_template/path as anything in subtypesof(/datum/jigsaw_template))
		if(path.abstract_type == path)
			continue
		var/datum/jigsaw_template/template = fetch_cached_jigsaw_template(path)
		result.weighted_templates[template] = 1
	return result

/datum/jigsaw_template_config/specific
	/// always start with these templates, if exists
	/// * may be typepaths or instances
	/// * this ignores budget and will not take from it.
	var/list/datum/jigsaw_template/initial_templates = list()
	/// * this ignores budget and will not take from it.
	var/list/datum/jigsaw_template/priority_templates = list()
	/// require placement of these templates, associate to count
	/// * if any of these fail to place, the generation fails
	/// * this ignores budget and will not take from it.
	var/list/datum/jigsaw_template/required_templates = list()

	/// templates to use, weighted.
	/// * may be typepaths or instances
	/// * this are constrained by budgets.
	var/list/datum/jigsaw_template/weighted_templates = list()

	/// allowed costs
	/// * only used for weighted templates
	var/list/budgets = list()

/datum/jigsaw_template_config/specific/get_resultant_config()
	var/datum/jigsaw_template_resultant_config/result = new
	result.initial_templates = initial_templates.Copy()
	result.weighted_templates = weighted_templates.Copy()
	result.priority_templates = priority_templates.Copy()
	result.required_templates = required_templates.Copy()
	results.budgets = budgets.Copy()
	return result
