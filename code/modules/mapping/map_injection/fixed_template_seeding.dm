//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Seeds a specific set of templates into
 * `fixed_template_seeding_target` helpers.
 */
/datum/map_injection/fixed_template_seeding
	/**
	 * Required templates by tag.
	 * * [tag] = list(templates = counts...)
	 * * templates may be a /datum/map_template path or instance.
	 * * templates may also be a /datum/map_template_random path or instance.
	 */
	var/list/require = list()
	/**
	 * Spawn this many templates, by tag.
	 * * Second priority after 'require'.
	 * * [tag] = list(templates = counts...)
	 * * templates may be a /datum/map_template path or instance.
	 * * templates may also be a /datum/map_template_random path or instance.
	 */
	var/list/push = list()
	/**
	 * Fill unused targets.
	 * * This is a weight based system rather than count.
	 * * Total weight is counted per tag. This may be slow if there's too many
	 *   matching tags, so be careful.
	 * * [tag] = list(templates = counts...)
	 * * templates may be a /datum/map_template path or instance.
	 * * templates may also be a /datum/map_template_random path or instance.
	 */
	var/list/fill = list()

#warn impl

/datum/map_injection/fixed_template_seeding/on_map_pre_init(datum/map_context/context)
	. = ..()
#warn impl
