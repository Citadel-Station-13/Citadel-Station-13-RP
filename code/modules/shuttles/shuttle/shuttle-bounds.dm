//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Returns axis-aligned bounding box ordered turfs at our current location.
 * * This does not filter by our shuttle's area, so it may return turfs that are not actually inside us.
 */
/datum/shuttle/proc/aabb_ordered_turfs_here()
	return anchor.aabb_ordered_turfs_here()

/**
 * Returns axis-aligned bounding box ordered turfs at a given location / direction.
 * * This does not filter by our shuttle's area, so it may return turfs that are not actually inside us.
 */
/datum/shuttle/proc/aabb_ordered_turfs_at(turf/anchor, direction)
	return src.anchor.aabb_ordered_turfs_at(anchor, direction)

/**
 * Returns turfs at our current location.
 * * This does filter by our shuttle's area, so it will only return turfs that are actually inside us.
 */
/datum/shuttle/proc/shuttle_turfs_here()
	return SSgrids.filter_ordered_turfs_via_area(areas, aabb_ordered_turfs_here())

/**
 * Returns turfs at a given location / direction.
 * * This does filter by our shuttle's area, so it will only return turfs that are actually inside us.
 */
/datum/shuttle/proc/shuttle_turfs_at(turf/anchor, direction)
	return SSgrids.filter_ordered_turfs_via_area(areas, aabb_ordered_turfs_at(anchor, direction))

#warn consider rethinking how dock alignment works

/**
 * check bounding boxes
 *
 * basically, wrapper for check_bounding
 *
 * @params
 * * dock -  dock to dock to
 * * with_port - port to align with dock; if null, we do a centered docking
 * * abort_on_fault - fault level to abort checks on. we will never abort checks if bad_turfs_out is provided.
 * * bounds_checking_flags - SHUTTLE_BOUNDS_CHECKING_* flags
 * * use_ordered_turfs - pass in ordered turfs to use instead of the normal bounds check
 * * bad_turfs_out - passes back turfs that block bounds in any way. if this is not provided,
 *                   checks may short-circuit and abort on the first bad turf.
 *
 * @return SHUTTLE_BOUNDING_* define
 */
/datum/shuttle/proc/check_docking_bounds(
	obj/shuttle_dock/dock,
	obj/shuttle_aligner/port/with_port,
	abort_on_fault = SHUTTLE_BOUNDING_HARD_FAULT,
	bounds_checking_flags,
	list/turf/use_ordered_turfs,
	list/bad_turfs_out
)
	var/turf/to_loc
	var/to_dir

	if(with_port)
		var/list/result = anchor.calculate_resultant_motion_from_docking

	return check_bounding(to_loc, to_dir, abort_on_fault, bounds_checking_flags, use_ordered_turfs, bad_turfs_out, dock)

#warn we're going to need a way to allow crashing into things liek trees..

/**
 * direct bounding box check
 *
 * @params
 * * turf/location - location anchor will be at
 * * direction - direction anchor will be at
 * * abort_on_fault - fault level to abort checks on. we will never abort checks if bad_turfs_out is provided.
 * * bounds_checking_flags - SHUTTLE_BOUNDS_CHECKING_* flags
 * * use_ordered_turfs - pass in ordered turfs to use instead of the normal bounds check
 * * bad_turfs_out - passes back turfs that block bounds in any way. if this is not provided,
 *                   checks may short-circuit and abort on the first bad turf.
 * * dock_going_to - if specified, ignore this dock for bounds protections
 */
/datum/shuttle/proc/check_bounding(
	turf/location,
	direction,
	abort_on_fault = SHUTTLE_BOUNDING_HARD_FAULT,
	bounds_checking_Flags,
	list/use_ordered_turfs,
	list/bad_turfs_out,
	obj/shuttle_dock/dock_going_to
)
#warn below
	if(isnull(use_ordered_turfs))
		use_ordered_turfs = anchor.aabb_ordered_turfs_at_and_clip_check(location, direction)
		SSgrids.filter_ordered_turfs_via_area(areas, use_ordered_turfs)
	if(isnull(use_ordered_turfs))
		return SHUTTLE_BOUNDING_HARD_FAULT
	if(hard_checks_only)
		return SHUTTLE_BOUNDING_CLEAR
	for(var/obj/shuttle_dock/enemy_dock in SSshuttle.docks_by_level[location.z])
		if(enemy_dock == docking_at)
			continue
		if(!enemy_dock.should_protect_bounding_box())
			continue
		if(!anchor.intersects_dock(enemy_dock))
			continue
		// we do intersect
		return SHUTTLE_BOUNDING_SOFT_FAULT
	if(!check_bounding_trample_turfs_binary(use_ordered_turfs))
		return SHUTTLE_BOUNDING_SOFT_FAULT
	return SHUTTLE_BOUNDING_CLEAR

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
