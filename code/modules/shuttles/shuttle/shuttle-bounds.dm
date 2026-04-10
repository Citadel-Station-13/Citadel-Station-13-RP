//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

#warn rework this file, need clearer soft / hard / error out / warning out's
#warn use max() for _BOUNDING_* returns

/**
 * check bounding boxes
 *
 * basically, wrapper for check_bounding
 *
 * @params
 * * dock -  dock to dock to
 * * with_port - port to align with dock; if null, we do a centered docking
 * * hard_checks_only - only check for hard faults. this is usually set to TRUE for dock landings, because docks are consdiered protected!
 * * use_ordered_turfs - pass in ordered turfs to use instead of the normal bounds check
 */
/datum/shuttle/proc/check_docking_bounds(obj/shuttle_dock/dock, obj/shuttle_aligner/port/with_port, hard_checks_only, list/turf/use_ordered_turfs)
	if(isnull(hard_checks_only))
		hard_checks_only = dock.trample_bounding_box
	#warn impl

#warn we're going to need a way to allow crashing into things liek trees..

/**
 * direct bounding box check
 *
 * @params
 * * turf/location - location anchor will be at
 * * direction - direction anchor will be at
 * * hard_checks_only - only check for hard faults
 * * use_ordered_turfs - pass in ordered turfs to use instead of the normal bounds check.
 *                       if you do, you are expected to 'clip check' this for other docks already!
 * * docking_at - dock we're going to. used to exclude it from dock boundary checks.
 */
/datum/shuttle/proc/check_bounding(turf/location, direction, hard_checks_only, list/turf/use_ordered_turfs, obj/shuttle_dock/docking_at)
	if(isnull(use_ordered_turfs))
		use_ordered_turfs = anchor.aabb_ordered_turfs_at_and_clip_check(location, direction)
		SSgrids.filter_ordered_turfs_via_area(areas, use_ordered_turfs)
	if(isnull(use_ordered_turfs))
		return SHUTTLE_DOCKING_BOUNDING_HARD_FAULT
	if(hard_checks_only)
		return SHUTTLE_DOCKING_BOUNDING_CLEAR
	for(var/obj/shuttle_dock/enemy_dock in SSshuttle.docks_by_level[location.z])
		if(enemy_dock == docking_at)
			continue
		if(!enemy_dock.should_protect_bounding_box())
			continue
		if(!anchor.intersects_dock(enemy_dock))
			continue
		// we do intersect
		return SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT
	if(!check_bounding_trample_turfs_binary(use_ordered_turfs))
		return SHUTTLE_DOCKING_BOUNDING_SOFT_FAULT
	return SHUTTLE_DOCKING_BOUNDING_CLEAR

/**
 * called binary because we return TRUE / FALse only
 *
 * @return FALSE if we will trample something
 */
/datum/shuttle/proc/check_bounding_trample_turfs_binary(list/checking)
	for(var/turf/T as anything in checking)
		if(!check_bounding_trample_turf(T))
			return FALSE
	return TRUE

/**
 * @params
 * * checking - turfs to check
 * * bad_turfs_out - turfs that get trampled are put in here
 *
 * @return FALSE if we will trample something
 */
/datum/shuttle/proc/check_bounding_trample_turfs_extract(list/checking, list/bad_turfs_out = list())
	. = TRUE
	for(var/turf/T as anything in checking)
		if(isnull(T))
			continue
		if(!check_bounding_trample_turf(T))
			. = FALSE
			bad_turfs_out += T

/**
 * @params
 * * ordered_turfs - turfs to check
 * * bad_turfs_out - turfs that get trampled are put in here, rest of entries are null. same ordering as ordered_turfs
 *
 * @return FALSE if we will trample something
 */
/datum/shuttle/proc/check_bounding_trample_turfs_ordered_extract(list/ordered_turfs, list/bad_turfs_out = list())
	. = TRUE
	bad_turfs_out.len = length(ordered_turfs)
	for(var/i in 1 to length(ordered_turfs))
		var/turf/T = ordered_turfs[i]
		if(isnull(T))
			continue
		if(!check_bounding_trample_turf(T))
			. = FALSE
			bad_turfs_out[i] = T
		else
			bad_turfs_out[i] = null

/**
 * soft bounding check - override this for your own checks.
 *
 * @return FALSE if trampling sometihng we don't want to trample
 */
/datum/shuttle/proc/check_bounding_trample_turf(turf/T)
	// 1. are we space?
	if(istype(T, /turf/space))
		// we're fine
		return TRUE
	// 2. is the turf dense?
	if(T.density)
		// don't run it over
		return FALSE
	// 3. is the turf outdoors?
	if(!T.outdoors)
		// no landing indoors unless it's a dock
		return FALSE
	return TRUE
