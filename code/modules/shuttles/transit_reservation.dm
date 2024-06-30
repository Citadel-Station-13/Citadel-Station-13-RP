//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/turf_reservation/transit
	var/obj/shuttle_dock/transit/transit_dock

/datum/turf_reservation/transit/proc/prepare_dock(datum/shuttle/shuttle, direction)
	ASSERT(!transit_dock)

	#warn impl / replace

	// var/center_x = floor(world.maxx / 2)
	// var/center_y = floor(world.maxy / 2)
	// var/low_x = center_x - floor(width / 2)
	// var/low_y = center_y - floor(height / 2)
	// var/high_x = low_x + width - 1
	// var/high_y = low_y + width - 1

	// transit_dock = create_shuttle_dock(
	// 	locate(low_x, low_y, z_index),
	// 	with_dir = dir,
	// 	lx_ly_hx_hy = list(
	// 		low_x,
	// 		low_y,
	// 		high_x,
	// 		high_y,
	// 	),
	// )

	return TRUE

/**
 * transit docks
 *
 * * we do not receive shuttle events, as we're considered an ephemeral / otherwise not a useful dock
 * * /obj/shuttle_dock/freeflight docks do receive shuttle events.
 */
/obj/shuttle_dock/transit
	centered_landing_allowed = TRUE
	centered_landing_only = TRUE
	protect_bounding_box = TRUE
