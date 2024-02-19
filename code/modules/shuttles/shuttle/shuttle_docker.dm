//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Shuttle custom docking handler
 */
/datum/shuttle_docker
	/// our host shuttle
	var/datum/shuttle/shuttle

	/// our current orientation
	var/orientation

#warn impl all

/**
 * Returns a list of name-to-turf of valid jump points
 */
/datum/shuttle_docker/proc/docking_beacons(zlevel)
	RETURN_TYPE(/list)
	. = list(
		"-- Center --" = locate(world.maxx / 2, world.maxy / 2, zlevel),
	)
	for(var/obj/shuttle_dock/dock as anything in SSshuttle.docks_by_level[zlevel])
		var/i = 0
		if(!dock.manual_docking_beacon)
			continue
		if(.[dock.display_name])
			while(.["[dock.display_name] [++i]"])
				continue
			.["[dock.display_name] [++i]"] = dock
		else
			.[dock.display_name] = get_turf(dock)
