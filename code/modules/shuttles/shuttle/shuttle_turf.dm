//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * indestructible superstructure baseturf at bottom of shuttle
 */
/turf/shuttle_structure
	name = "shuttle superstructure"
	desc = "The nigh-indestructible allow framework making up the parts of a modern shuttle."
	#warn sprite - smoothed
	// todo: this shouldn't interfere with meteors or anything
	density = FALSE
	pass_flags_self = ATOM_PASS_ALL

	#warn atmos
	#warn zmimic
