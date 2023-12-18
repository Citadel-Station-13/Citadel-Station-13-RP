//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * hooks fired off when shuttles takeoff/landing
 */
/datum/shuttle_hook
	/// if non-null, this is the string / error we report; if list, it's a list of strings.
	var/list/error_reports

/datum/shuttle_hook/proc/pre_landing(obj/docking_port/port)

/datum/shuttle_hook/proc/on_landing(obj/docking_port/port)

/datum/shuttle_hook/proc/post_landing(obj/docking_port/port)

/datum/shuttle_hook/proc/pre_takeoff(obj/docking_port/port)

/datum/shuttle_hook/proc/on_takeoff(obj/docking_port/port)

/datum/shuttle_hook/proc/post_takeoff(obj/docking_port/port)

/datum/shuttle_hook/proc/force_takeoff(obj/docking_port/port)

/datum/shuttle_hook/proc/failed_takeoff(obj/docking_port/port)

