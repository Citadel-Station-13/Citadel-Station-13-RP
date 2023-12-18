//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * the physical shuttle object
 *
 * for aligned docks, we align the direction and the tile to the shuttle dock.
 */
/obj/shuttle_anchor
	name = "Shuttle (uninitialized)"
	desc = "Why do you see this?"
	#warn sprite

	/// shuttle datum to init - typepath
	var/shuttle_datum_typepath
	/// shuttle datum
	var/datum/shuttle/shuttle

#warn impl all
