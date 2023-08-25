//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/controller/subsystem/mapping/proc/lookup_indoors_air(z)
	if(!z)	// nullspace
		return
	return ordered_levels[z].air_indoors

/datum/controller/subsystem/mapping/proc/lookup_outdoors_air(z)
	if(!z)	// nullspace
		return
	return ordered_levels[z].air_outdoors
