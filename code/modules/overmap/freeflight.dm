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

/datum/map_level/freeflight/proc/make_leader_dock(width, height, dir)
	#warn check size x/y
	#warn uhh

/**
 * freeflight docks
 */
/obj/shuttle_dock/freeflight
	// always aligned landing
	centered_landing_allowed = FALSE
	// no one can block us
	protect_bounding_box = TRUE

#warn protect bounding box for larger area than usual
