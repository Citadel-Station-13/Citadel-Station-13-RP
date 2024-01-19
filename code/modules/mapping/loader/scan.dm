//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: everything

/**
 * found object
 */
/datum/dmm_scan_result
	/// path of object
	var/path
	/// key-value of variables
	var/list/varedits
	/// x
	var/x
	/// y
	var/y
	/// z
	var/z
	/// dir - cached
	var/dir_cached

/datum/dmm_scan_result/proc/get_dir()
	#warn impl via cache, initial, and varedit list

/**
 * return dmm_scan_results of every type in the typecache that exists in our parsed map
 */
/datum/dmm_parsed/proc/scan_for(list/typecache)
	RETURN_TYPE(/list)
	#warn impl
