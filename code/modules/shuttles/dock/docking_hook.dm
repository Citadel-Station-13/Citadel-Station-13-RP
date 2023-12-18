//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * hook datums able to be added to docking ports.
 */
/datum/docking_hook
	/// if non-null, this is the string / error we report; if list, it's a list of strings.
	var/list/error_reports

/datum/docking_hook/proc/pre_landing(datum/shuttle/shuttle)

/datum/docking_hook/proc/on_landing(datum/shuttle/shuttle)

/datum/docking_hook/proc/post_landing(datum/shuttle/shuttle)

/datum/docking_hook/proc/pre_takeoff(datum/shuttle/shuttle)

/datum/docking_hook/proc/on_takeoff(datum/shuttle/shuttle)

/datum/docking_hook/proc/post_takeoff(datum/shuttle/shuttle)
