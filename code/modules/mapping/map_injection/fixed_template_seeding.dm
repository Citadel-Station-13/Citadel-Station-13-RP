//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Seeds a specific set of templates into
 * `fixed_template_seeding_target` helpers.
 */
/datum/map_injection/fixed_template_seeding
	/**
	 * Required templates. Highest priority.
	 * * list(/datum/fixed_template_seeding_single = count, ...)
	 */
	var/list/require = list()
	/**
	 * Push these templates. Second priority.
	 * * list(/datum/fixed_template_seeding_single = count, ...)
	 */
	var/list/push = list()
	/**
	 * Fill unused targets.
	 * * This is a weight based system rather than count.
	 * * Total weight is counted per tag on an unused target.
	 *   This may be slow if there's too many
	 *   matching tags or targets, so be careful.
	 * * [tag] = list(templates = counts...)
	 * * templates may be a /datum/map_template path or instance.
	 * * templates may also be a /datum/map_template_random path or instance.
	 */
	var/list/fill = list()

#warn impl

/datum/map_injection/fixed_template_seeding/on_map_pre_init(datum/map_context/context)
	. = ..()
#warn impl

/datum/fixed_template_seeding_single
	/// template-like associated to tag
	/// * /datum/map_template_random accepted as well.
	var/list/templates = list()

/**
 * Just to namespace map-specific from polluting types.
 */
/datum/fixed_template_seeding_single/map_specific
