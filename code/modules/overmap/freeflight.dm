//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// todo: where should this file go / the stuff in it go?

/**
 * freeflight levels used by overmaps for shuttle interdictions
 */
/datum/map_level/freeflight
	transition = Z_TRANSITION_FORCED

	/// the current owning entity
	var/obj/overmap/entity/visitable/ship/landable/leader
	/// the overmap entities within us
	///
	/// * this does include the [leader]!
	var/list/obj/overmap/entity/visitable/ship/landable/visiting = list()
	/// the leader's dock
	var/obj/shuttle_dock/freeflight/leader_dock

/datum/map_level/freeflight/New(datum/map/parent_map)
	..()
	dangerously_make_selflooping()

/**
 * makes an anchor-aligned dock for a shuttle to land at the center of the sector.
 *
 * @params
 * * width - real width (x coord)
 * * height - real height (y coord)
 * * dir - direction of shuttle
 */
/datum/map_level/freeflight/proc/make_leader_dock(width, height, dir)
	ASSERT(!leader_dock)

	var/center_x = floor(world.maxx / 2)
	var/center_y = floor(world.maxy / 2)
	var/low_x = center_x - floor(width / 2)
	var/low_y = center_y - floor(height / 2)
	var/high_x = low_x + width - 1
	var/high_y = low_y + width - 1

	leader_dock = create_shuttle_dock(
		locate(low_x, low_y, z_index),
		with_dir = dir,
		lx_ly_hx_hy = list(
			low_x,
			low_y,
			high_x,
			high_y,
		),
	)

	return TRUE

/**
 * freeflight docks
 */
/obj/shuttle_dock/freeflight
	// always centered landing
	centered_landing_allowed = TRUE
	centered_landing_only = TRUE
	// always trample
	trample_bounding_box = TRUE
	// no one can block us
	protect_bounding_box = TRUE

#warn protect bounding box for larger area than usual
