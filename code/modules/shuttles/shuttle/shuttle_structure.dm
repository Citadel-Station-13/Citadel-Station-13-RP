//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * indestructible superstructure baseturf at bottom of shuttle
 */
/obj/shuttle_structure
	name = "shuttle superstructure"
	desc = "The nigh-indestructible alloy frame of a shuttle."
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	obj_flags = NONE
	#warn sprite + smoothing
	// todo: this shouldn't interfere with meteors or anything
	density = FALSE
	pass_flags_self = ATOM_PASS_ALL

/obj/shuttle_structure/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE
	return ..()

/obj/shuttle_structure/Move(...)
	return FALSE

/obj/shuttle_structure/doMove(atom/destination)
	return FALSE

// grid moves handling

/obj/shuttle_structure/grid_move(grid_flags, turf/new_turf)
	loc = new_turf

/obj/shuttle_structure/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	return

/obj/shuttle_structure/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return

/obj/shuttle_structure/grid_finished(grid_flags, rotation_angle)
	return

#warn above should be also implemented on anchor, and port.
