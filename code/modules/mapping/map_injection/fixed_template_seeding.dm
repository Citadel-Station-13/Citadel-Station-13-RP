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

/datum/map_injection/fixed_template_seeding/on_map_pre_init(datum/map_context/map_context, datum/dmm_context/dmm_context)
	..()

	var/list/obj/map_helper/fixed_template_seeding_target/not_emplaced = map_context?.collected_fixed_template_seeding_targets.Copy()
	var/list/obj/map_helper/fixed_template_seeding_target/emplace_templates = list()

	for(var/datum/fixed_template_seeding_single/require_single in shuffle(src.require))
		if(!length(not_emplaced))
			stack_trace("Failed to assign required template '[require_single]' for injection [src] ([REF(src)]) (no more targets).")
			break

		var/datum/fixed_template_seeding_single/require_amount = src.require[require_single]
		for(var/i in 1 to require_amount)
			if(!require_single.attempt_assign(not_emplaced, emplace_templates))
				// TODO: better error handling
				stack_trace("Failed to assign required template '[require_single]' for injection [src] ([REF(src)]) (failed on [i] / [require_amount]).")
				break

	for(var/datum/fixed_template_seeding_single/push_single in shuffle(src.push))
		if(!length(not_emplaced))
			break

		var/datum/fixed_template_seeding_single/push_amount = src.push[push_single]
		for(var/i in 1 to push_amount)
			if(!push_single.attempt_assign(not_emplaced, emplace_templates))
				// TODO: better error handling
				break

	if(length(not_emplaced))
#warn impl

/datum/fixed_template_seeding_single
	/// template-like associated to tag
	/// * /datum/map_template_random accepted as well.
	var/list/templates = list()

/datum/fixed_template_seeding_single/proc/attempt_assign(list/obj/map_helper/fixed_template_seeding_target/pull_from, list/obj/map_helper/fixed_template_seeding_target/assign_into)
	#warn impl

/**
 * Just to namespace map-specific from polluting types.
 */
/datum/fixed_template_seeding_single/map_specific
