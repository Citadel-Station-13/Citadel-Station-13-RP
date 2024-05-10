//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Shuttle custom docking handler
 */
/datum/shuttle_docker
	/// our host shuttle
	var/datum/shuttle/shuttle
	/// host datum, if any. this is usually the datum the user is interacting with, like a console
	/// or an admin panel.
	var/datum/host

	/// our current turf
	var/turf/position
	/// tile offset of position 'into' shuttle bounding box, y (1 = we're on y = 2)
	var/center_y = 0
	/// tile offset of position 'into' shuttle bounding box, x (1 = we're on x = 2)
	var/center_x = 0
	/// our current orientation
	var/orientation

	/// the mob using us
	var/mob/user
	#warn actor-performer crap
	/// used perspective
	var/datum/perspective/used_perspective

	/// call with proposed position and ourselves when the user tries to designate a location
	/// call pattern: (turf/lower_left, mob/user, datum/shuttle_docker/docker)
	/// return FALSE to forbid docking.
	var/datum/callback/on_target

/datum/shuttle_docker/New(datum/shuttle/shuttle, datum/host, mob/user, datum/callback/on_target)
	src.shuttle = shuttle
	src.host = host
	src.on_target = on_target
	used_perspective = new
	capture_user(user)

/datum/shuttle_docker/Destroy()
	if(user)
		release_user()
	on_target = null
	position = null
	host = null
	shuttle = null
	QDEL_NULL(used_perspective)
	return ..()

/datum/shuttle_docker/proc/capture_user(mob/user)
	#warn impl

/datum/shuttle_docker/proc/release_user()
	#warn impl

	#warn /datum/remote_control..?

/datum/shuttle_docker/proc/set_position(turf/position)
	#warn impl

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

/datum/action/designate_manual_shuttle_landing

/datum/action/exit_manual_shuttle_landing

#warn impl
