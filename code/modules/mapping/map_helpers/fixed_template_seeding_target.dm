//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * For /datum/map_injection/fixed_template_seeding.
 *
 * * This allows specific tags to be spawned here.
 * * As of right now, this has no checks on maximum size. Make your tags accordingly.
 */
/obj/map_helper/fixed_template_seeding_target
	/**
	 * Target tags for the template seeding.
	 * * Optionally associate a tag to a number to weight it.
	 *   Injection gets final say.
	 */
	var/list/allow_tags = list(
		"default" = 1,
	)

	var/emplaced = FALSE

/obj/map_helper/fixed_template_seeding_target/map_initializations(datum/dmm_context/dmm_context, datum/map_context/map_context)
	..()
	map_context?.collected_fixed_template_seeding_targets += src

/obj/map_helper/fixed_template_seeding_target/proc/emplace_template(datum/map_template/template, datum/dmm_context/context)
	SHOULD_NOT_OVERRIDE(TRUE)

	emplaced = TRUE
	do_emplace_template(template, context)

/obj/map_helper/fixed_template_seeding_target/proc/do_emplace_template(datum/map_template/template, datum/dmm_context/context)
	PROTECTED_PROC(TRUE)
#warn impl

/obj/map_helper/fixed_template_seeding_target/corner_aligned
#warn impl; do dirs too + icons
