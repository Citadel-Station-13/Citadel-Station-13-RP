//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/map_template_random
	/**
	 * A list of templates with associated weights.
	 * * The system will pick one of these templates to load, based on the weights.
	 */
	var/list/weighted_templates = list()

/datum/map_template_random/proc/get_template()
	return pickweightAllowZero(weighted_templates)
