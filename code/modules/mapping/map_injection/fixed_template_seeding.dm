//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Seeds a specific set of templates into
 * `fixed_template_seeding_target` helpers.
 */
/datum/map_injection/fixed_template_seeding
	/**
	 * Required templates by tag.
	 */
	var/list/require = list()
	/**
	 * Spawn this many templates, by tag.
	 * * Second priority after 'require'.
	 */
	var/list/push = list()
	/**
	 * Fill unused targets.
	 * * This is a weight based system rather than count.
	 * * Total weight is counted per tag. This may be slow if there's too many
	 *   matching tags, so be careful.
	 * * Example: fill = list("science" = list(/datum/map_template/my_map_template/anomaly_store = 1, ...))
	 */
	var/list/fill = list()

#warn impl
