//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_template_resultant_config
	/// always start with these templates, if exists
	/// * may be typepaths or instances
	var/list/datum/jigsaw_template/initial_templates = list()
	/// templates to use, weighted.
	/// * may be typepaths or instances
	var/list/datum/jigsaw_template/weighted_templates = list()
	/// ***attempt*** to place these templates, associate to count
	/// * these are given priority during broadphase and narrowphase but it still isn't guaranteed
	var/list/datum/jigsaw_template/priority_templates = list()
	/// require placement of these templates, associate to count
	/// * if any of these fail to place, the generation fails
	/// * only convex templates are allowed in here because only broadphase can
	///   actually backtrack here.
	var/list/datum/jigsaw_template/required_templates = list()

/datum/jigsaw_template_config

/datum/jigsaw_template_config/proc/get_resultant_config() as /datum/jigsaw_template_resultant_config
	return new /datum/jigsaw_template_resultant_config

/datum/jigsaw_template_config/everything

/datum/jigsaw_template_config/everything/get_resultant_config()
	var/datum/jigsaw_template_resultant_config/result = new
	for(var/datum/jigsaw_template/path as anything in subtypesof(/datum/jigsaw_template))
		if(path.abstract_type == path)
			continue
		var/datum/jigsaw_template/template = fetch_cached_jigsaw_template(path)
		result.weighted_templates[template] = 1
	return result

/datum/jigsaw_template_config/specific
	/// always start with these templates, if exists
	/// * may be typepaths or instances
	var/list/datum/jigsaw_template/initial_templates = list()
	/// templates to use, weighted.
	/// * may be typepaths or instances
	var/list/datum/jigsaw_template/weighted_templates = list()
	/// ***attempt*** to place these templates, associate to count
	/// * these are given priority during broadphase and narrowphase but it still isn't guaranteed
	var/list/datum/jigsaw_template/priority_templates = list()
	/// require placement of these templates, associate to count
	/// * if any of these fail to place, the generation fails
	/// * only convex templates are allowed in here because only broadphase can
	///   actually backtrack here.
	var/list/datum/jigsaw_template/required_templates = list()

/datum/jigsaw_template_config/specific/get_resultant_config()
	var/datum/jigsaw_template_resultant_config/result = new
	result.initial_templates = initial_templates.Copy()
	result.weighted_templates = weighted_templates.Copy()
	result.priority_templates = priority_templates.Copy()
	result.required_templates = required_templates.Copy()
	return result
