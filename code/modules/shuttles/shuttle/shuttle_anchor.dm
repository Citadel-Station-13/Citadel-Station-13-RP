//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * the physical shuttle object
 *
 * for aligned docks, we align the direction and the tile to the shuttle dock.
 *
 * ## Bounds
 *
 * size_x, size_y describes our total bounding box size when facing NORTH.
 * offset_x, offset_y describes where the anchor is when facing NORTH.
 *
 * The anchor is always aligned to the top left, with no offsets, in this way.
 * When rotated it is where it would be when rotated counterclockwise to the new position.
 *
 * For a size_x, size_y of 6, 4:
 *
 * offset_x, offset_y = 0, dir NORTH
 *
 * ^00000
 * 000000
 * 000000
 * 000000
 *
 * offset_x, offset_y = 0, dir SOUTH
 *
 * 000000
 * 000000
 * 000000
 * 00000V
 *
 * offset_x, offset_y = 0, dir WEST
 *
 * 0000
 * 0000
 * 0000
 * 0000
 * 0000
 * <000
 *
 * offset_x, offset_y = 3, -1, dir NORTH
 *
 * 000000
 * 000^00
 * 000000
 * 000000
 *
 * offset_x, offset_y = 3, -1, dir SOUTH
 *
 * 000000
 * 000000
 * 00V000
 * 000000
 *
 * offset_x, offset_y = 3, -1, dir WEST
 *
 * 0000
 * 0000
 * 0<00
 * 0000
 * 0000
 * 0000
 *
 * Offsets can position the anchor outside. This works, albeit is a bad idea.
 *
 * ## Mappers
 *
 * * You don't need to put down anchors at all, they auto-generate.
 * * If you place one anyways, it'll be respected. That said, the size will be auto-generated too.
 *
 * Do not mess with the variables; the init system will set them.
 */
/obj/shuttle_anchor
	name = "Shuttle (uninitialized)"
	desc = "Why do you see this?"
	// by default this should be north.
	dir = NORTH
	icon = 'icons/modules/shuttles/shuttle_anchor.dmi'
	icon_state = "main"
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_SHUTTLE_MARKERS
	atom_flags = ATOM_ABSTRACT | ATOM_NONWORLD

#ifndef CF_SHUTTLE_VISUALIZE_BOUNDING_BOXES
	invisibility = INVISIBILITY_ABSTRACT
#else
	invisibility = INVISIBILITY_NONE
#endif

	/// shuttle datum
	var/tmp/datum/shuttle/shuttle

	/// see main documentation
	var/tmp/size_x
	/// see main documentation
	var/tmp/size_y
	/// see main documentation
	var/tmp/offset_x
	/// see main documentation
	var/tmp/offset_y

	/// are we moving right now?
	var/tmp/anchor_moving = FALSE

// This file is WIP, and is just here so mappers can start using them.

//* Movement Hooks ; We don't allow normal movement. *//

/obj/shuttle_anchor/forceMove()
	CRASH("attempted to forcemove a shuttle anchor")

/obj/shuttle_anchor/setDir(ndir)
	if(!anchor_moving)
		CRASH("attempted to setDir an anchor")
	return ..()

/obj/shuttle_anchor/abstract_move(atom/new_loc)
	if(!anchor_moving)
		CRASH("attempted to abstract_move a shuttle anchor")
	return ..()

//* Grid Hooks ; Shuttle manually moves us. *//

/obj/shuttle_anchor/grid_move(grid_flags, turf/new_turf)
	return

/obj/shuttle_anchor/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	return

/obj/shuttle_anchor/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return

/obj/shuttle_anchor/grid_finished(grid_flags, rotation_angle)
	return
