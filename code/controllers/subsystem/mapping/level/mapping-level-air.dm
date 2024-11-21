//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/controller/subsystem/mapping/proc/level_indoors_air(z)
	if(!z)	// nullspace
		return
	return ordered_levels[z].air_indoors

/datum/controller/subsystem/mapping/proc/level_outdoors_air(z)
	if(!z)	// nullspace
		return
	return ordered_levels[z].air_outdoors
