//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Returns all crosslinked z indices
 */
/datum/controller/subsystem/mapping/proc/crosslinked_levels()
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/map_level/L as anything in ordered_levels)
		if(L.linkage == Z_LINKAGE_CROSSLINKED)
			. += L.z_index
