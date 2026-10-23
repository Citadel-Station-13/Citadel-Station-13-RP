//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_template_config

/datum/jigsaw_template_config/clone()
	var/datum/jigsaw_template_config/clone = new type
	return clone

/datum/jigsaw_template_config/proc/get_resultant_config() as /datum/jigsaw_template_resultant_config
	return new /datum/jigsaw_template_resultant_config

/datum/jigsaw_template_config/everything

#warn add pack support?

/datum/jigsaw_template_config/everything/clone()
	var/datum/jigsaw_template_config/everything/clone = new
	return clone

/datum/jigsaw_template_config/everything/get_resultant_config()
	var/datum/jigsaw_template_resultant_config/result = new
	for(var/datum/prototype/jigsaw_template/path as anything in subtypesof(/datum/prototype/jigsaw_template))
		if(path.abstract_type == path)
			continue
		var/datum/prototype/jigsaw_template/template = RSjigsaw_templates.fetch_local_or_throw(path)
		result.weighted_templates[template] = 1
	return result

/datum/jigsaw_template_config/specific
	/// require placement of these templates, associate to count
	/// * if any of these fail to place, the generation fails
	/// * this ignores budget and will not take from it.
	var/list/datum/prototype/jigsaw_template/required_templates = list()
	/// attempt placement of these before weighted templates, but not before required
	/// * this ignores budget and will not take from it.
	/// * may be typepaths or instances
	var/list/datum/prototype/jigsaw_template/priority_templates = list()

	/// templates to use, weighted.
	/// * may be typepaths or instances
	/// * this are constrained by budgets.
	var/list/datum/prototype/jigsaw_template/weighted_templates = list()

#warn add pack support?

/datum/jigsaw_template_config/specific/clone()
	var/datum/jigsaw_template_config/specific/clone = ..()

	clone.weighted_templates = src.weighted_templates.Copy()
	clone.priority_templates = src.priority_templates.Copy()
	clone.required_templates = src.required_templates.Copy()

	return clone

/datum/jigsaw_template_config/specific/get_resultant_config()
	var/datum/jigsaw_template_resultant_config/result = new
	result.weighted_templates = weighted_templates.Copy()
	result.priority_templates = priority_templates.Copy()
	result.required_templates = required_templates.Copy()
	return result
