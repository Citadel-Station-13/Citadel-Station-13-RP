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

	if(emplaced)
		CRASH("attempted to double-emplace template [template] into [src] ([REF(src)]) at coords [COORD(src)]")

	emplaced = TRUE
	do_emplace_template(template, context)

/obj/map_helper/fixed_template_seeding_target/proc/do_emplace_template(datum/map_template/template, datum/dmm_context/context)
	PROTECTED_PROC(TRUE)
	CRASH("not implemented")

/obj/map_helper/fixed_template_seeding_target/corner_aligned
	#warn sprite for this and subtypes

	icon_x_dimension = 96
	icon_y_dimension = 96

/obj/map_helper/fixed_template_seeding_target/corner_aligned/do_emplace_template(datum/map_template/template, datum/dmm_context/context)
	PROTECTED_PROC(TRUE)

	// we're always on the corner, so we just have to align it with us and do orientation stuff

	template.load_standalone(target_corner, orientation = ORIENTATION_SOUTH)

	var/width = template.width
	var/height = template.height
	var/sideways = orientation & (EAST|WEST)
	var/real_width = sideways? height : width
	var/real_height = sideways? width : height

#warn impl; do dirs too + icons

/obj/map_helper/fixed_template_seeding_target/corner_aligned/bottom_left
	icon_state = "bottom_left"
	pixel_x = 0
	pixel_y = 0

/obj/map_helper/fixed_template_seeding_target/corner_aligned/bottom_right
	icon_state = "bottom_right"
	pixel_x = -64
	pixel_y = 0

/obj/map_helper/fixed_template_seeding_target/corner_aligned/top_left
	icon_state = "top_left"
	pixel_x = 0
	pixel_y = -64

/obj/map_helper/fixed_template_seeding_target/corner_aligned/top_right
	icon_state = "top_right"
	pixel_x = -64
	pixel_y = -64
