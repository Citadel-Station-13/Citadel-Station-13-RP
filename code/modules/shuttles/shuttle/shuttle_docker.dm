//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Shuttle custom docking handler
 * * Always provides alignment via the master (anchor) aligner.
 */
/datum/shuttle_docker
	/// our host shuttle
	var/datum/shuttle/shuttle
	/// host datum, if any. this is usually the datum the user is interacting with, like a console
	/// or an admin panel.
	var/datum/host

	/// our current eye
	/// * its dir is our dir
	var/atom/movable/render/shuttle_docker/eye

	/// the actor initiating this
	var/datum/event_args/actor/actor

	/// used perspective
	var/datum/perspective/used_perspective

	/// call with proposed position and ourselves when the user tries to designate a location
	/// call pattern: (turf/lower_left, mob/user, datum/shuttle_docker/docker)
	/// return FALSE to forbid docking.
	var/datum/callback/on_target

	var/datum/action/shuttle_docker/designate/action_for_designate
	var/datum/action/shuttle_docker/exit/action_for_exit

	var/designate_in_progress = FALSE
	var/designate_time = 5 SECONDS

/datum/shuttle_docker/New(datum/shuttle/shuttle, datum/host, mob/user, datum/callback/on_target)
	src.shuttle = shuttle
	src.host = host
	src.on_target = on_target
	create_eye()
	used_perspective = new
	setup_perspective()
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

/datum/shuttle_docker/proc/create_eye()
	src.eye = new(shuttle.anchor.loc)
	src.eye.dir = shuttle.anchor.dir
	src.eye.vis_contents += shuttle.get_preview()

/datum/shuttle_docker/proc/capture_user(mob/user)
	#warn impl

/datum/shuttle_docker/proc/release_user()
	#warn impl

	#warn /datum/remote_control..?

/datum/shuttle_docker/proc/set_position(turf/position, dir = eye.dir)
	eye.forceMove(position)
	if(dir != eye.dir)
		eye.setDir(dir)

/datum/shuttle_docker/proc/setup_perspective()
	used_perspective.set_eye(eye)

	var/atom/movable/screen/plane_master/plane

	plane = used_perspective.planes.by_plane_type(
		/atom/movable/screen/plane_master/objs,
	)
	plane.alpha = 0

	plane = used_perspective.planes.by_plane_type(
		/atom/movable/screen/plane_master/mobs,
	)
	plane.alpha = 0

	used_perspective.SetSight(SEE_TURFS | SEE_SELF)

	used_perspective.see_in_dark = 14
	used_perspective.update_see_in_dark()

/**
 * Returns a list of name-to-turf of valid jump points
 */
/datum/shuttle_docker/proc/docking_beacons(zlevel)
	RETURN_TYPE(/list)
	. = list()
	.["-- Level Center --"] = locate(floor(world.maxx * 0.5), floor(world.maxy * 0.5), zlevel)
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
	var/datum/shuttle_controller/controller = shuttle.controller
	if(istype(controller))
		. += controller.manual_landing_beacons(zlevel)

/datum/action/shuttle_docker
	target_type = /datum/shuttle_docker

/datum/action/shuttle_docker/invoke_target(datum/shuttle_docker/target, datum/event_args/actor/actor)
	return ..()

/datum/action/shuttle_docker/designate

/datum/action/shuttle_docker/designate/invoke_target(datum/shuttle_docker/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return TRUE
	#warn impl

/datum/action/shuttle_docker/exit

/datum/action/shuttle_docker/exit/invoke_target(datum/shuttle_docker/target, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return TRUE
	qdel(target)
	return TRUE
