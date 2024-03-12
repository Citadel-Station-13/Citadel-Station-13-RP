//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_INIT(frame_datums, init_frame_datums())

/proc/init_frame_datums()

#warn global list

/datum/frame_new
	/// frame name
	var/name
	/// sheet metal cost
	var/material_cost = 1
	/// for future use: set to TRUE to allow all materials
	var/material_unlocked = FALSE

#warn impl

/**
 * requires a specific circuitboard, or just doesn't require one at all
 */
/datum/frame_new/preloaded

