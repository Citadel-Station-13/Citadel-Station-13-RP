//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * The movement manager for turf movements
 *
 * This is named after SS14's grids.
 * This is a subsystem for OOP/encapsulation reasons.
 */
SUBSYSTEM_DEF(grids)
	name = "Grids"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

	/// global motion mutex
	var/translation_mutex = FALSE


/**
 * gets ordered turfs for operation
 */
/datum/controller/subsystem/grids/proc/get_ordered_turfs(x1, x2, y1, y2, z, dir)
	#warn impl

/datum/controller/subsystem/grids/proc/rotation_angle(from_dir, to_dir)
	return (angle_to_dir(to_dir) - angle_to_dir(from_dir))

/datum/controller/subsystem/grids/proc/angle_to_dir(dir)
	switch(dir)
		if(NORTH)
			return 0
		if(SOUTH)
			return 180
		if(EAST)
			return 270
		if(WEST)
			return 90
		else
			CRASH("non-cardinal")

/**
 * performs turf translation
 *
 * baseturf boundary is important if you do not want things being ripped out of the ground.
 * without boundary set, turfs will be completely scraped down to their bottom baseturfs,
 * and destination turfs will have their baseturf stacks trampled by this.
 *
 * @params
 * * from_turfs - get_ordered_turfs return list
 * * from_dir - dir of from_turfs
 * * to_turfs - get_ordered_turfs return list
 * * to_dir - dir of to_turfs
 * * grid_flags - flags to pass during move to motion procs
 * * baseturf_boundary - if set, turfs move down to this baseturf boundary. if it's not there, the turf is automatically skipped.
 * * leave_area - the area instance to leave behind. if not set, this defaults to the base area of the zlevel.
 * * emit_motion_flags - use this to extract ordered motion flags
 * * emit_moved_atoms - use this to extract what movables got moved
 */
/datum/controller/subsystem/grids/proc/translate(list/from_turfs, list/to_turfs, from_dir, to_dir, grid_flags, baseturf_boundary, area/leave_area, list/emit_motion_flags = list(), list/emit_moved_atoms = list())
	// While based on /tg/'s movement system, we do a few things differently.
	// First, limitations:
	// * base-areas aren't a thing. Areas are flat out trampled on move. On takeoff, areas are reset.
	// * Turfs are assumed to be entirely described by baseturfs. So, flooring's just trampled too.
	// * Areas may be left behind if a bounding box doesn't completely envelop an area. There's not many ways to fix this, so make sure your bounding boxes do.
	// The actual process:
	// * Collect turfs, with order of opinions being area -> turf -> movable
	// * Move areas to their new turfs all at once
	// * Move turfs one by one
	// * Move movables to their new turfs
	// * Proc grid_after() on all areas -> turfs -> movables in these stages
	// * Cleanup areas from their old turfs all at once
	// * Cleanup turfs one by onew
	// * Proc grid_finished() on all registered movables
	// Caveats / Pointers:
	// * rotation_angle is in turn() angles.
	// * Collect is tick checked. IF you have a movable that affects things, it best be anchored or hard to move.
	// * Area / turf transfer is tick checked.
	// * Movable movement, and grid_after() calls aren't tick checked, as players can observe this.

	. = FALSE

	ASSERT(length(from_turfs) == length(to_turfs))

	/// motion flags corrosponding to ordered turfs. this is ordered. null turf --> null.
	var/list/ordered_motion_flags = emit_motion_flags
	/// list of area instances associated to turfs being moved from
	var/list/source_turfs_by_area = list()
	/// list of area instances associated to turfs being moved to
	var/list/destination_turfs_by_area = list()
	/// things moved
	var/list/atom/movable/moved = emit_moved_atoms
	/// for things that need a late / extra stage. these get grid_finished() called on it after everything
	var/list/atom/movable/late_callers = list()
	/// calculate rotation angle
	var/rotation_angle = rotation_angle(from_dir, to_dir)

	CHECK_TICK

	//* Collect
	for(var/i in 1 to length(from_turfs))
		var/turf/source = from_turfs[i]
		if(isnull(source))
			continue
		// if not null, we assume to_turfs is there.
		var/turf/destination = to_turfs[i]
		// we assume all turfs have areas
		var/area/source_area = source.loc
		// ask area -> turf -> movable
		// movable have the capability to 'insist' on moving something that is otherwise not supposed to move
		var/motion_flags = source_area.grid_collect(grid_flags, source, destination, baseturf_boundary)
		motion_flags = source.grid_collect(grid_flags, destination, baseturf_boundary, motion_flags)
		for(var/atom/movable/AM as anything in source)
			// no abstract check - abstract atoms can impact the collect cycle
			motion_flags = AM.grid_collect(grid_flags, destination, motion_flags)
		// add to ordered list
		ordered_motion_flags += motion_flags
		// if moving area, add to turfs_by_area
		if(motion_flags & GRID_MOVE_AREA)
			if(isnull(source_turfs_by_area[source_area]))
				source_turfs_by_area[source_area] = list(source)
				destination_turfs_by_area[source_area] = list(destination)
			else
				source_turfs_by_area[source_area] += source
				destination_turfs_by_area[source_area] += destination
		CHECK_TICK

	//* Transfer areas
	for(var/area/A as anything in source_turfs_by_area)
		A.grid_transfer(grid_flags, source_turfs_by_area[A], destination_turfs_by_area[A], baseturf_boundary)
		CHECK_TICK

	//* Transfer turfs
	for(var/i in 1 to length(from_turfs))
		var/turf/source = from_turfs[i]
		if(isnull(source))
			continue
		if(!(ordered_motion_flags[i] & GRID_MOVE_TURF))
			continue
		var/turf/destination = to_turfs[i]
		source.grid_transfer(grid_flags, destination, baseturf_boundary)
		CHECK_TICK

	//* Move movables - NO CHECK TICK
	for(var/i in 1 to length(from_turfs))
		var/turf/source = from_turfs[i]
		if(isnull(source))
			continue
		if(!(ordered_motion_flags[i] & GRID_MOVE_MOVABLES))
			continue
		var/turf/destination = to_turfs[i]
		for(var/atom/movable/AM as anything in source)
			if(AM.atom_flags & ATOM_ABSTRACT) // don't move
				continue
			if(AM.loc != source) // multi tile object check
				continue
			AM.grid_move(grid_flags, destination)
			moved += AM

	//* Moved - areas
	for(var/area/A as anything in source_turfs_by_area)
		A.grid_after(grid_flags, source_turfs_by_area[A], destination_turfs_by_area[A], baseturf_boundary)

	//* Moved - turfs
	for(var/i in 1 to length(to_turfs))
		var/turf/destination = to_turfs[i]
		if(isnull(destination))
			continue
		if(!(ordered_motion_flags[i] & GRID_MOVE_TURF))
			continue
		destination.grid_after(grid_flags, rotation_angle)

	//* Moved - movables
	for(var/atom/movable/AM as anything in moved)
		if(QDELETED(AM))
			continue
		AM.grid_after(grid_flags, rotation_angle, late_callers)

	//* Late - movables
	for(var/atom/movable/AM as anything in late_callers)
		if(QDELETED(AM))
			continue
		AM.grid_finished(grid_flags, rotation_angle)

	//* Cleanup areas
	for(var/area/A as anything in source_turfs_by_area)
		A.grid_clean(grid_flags, source_turfs_by_area[A], destination_turfs_by_area[A], baseturf_boundary, leave_area)
		CHECK_TICK

	//* Cleanup turfs
	for(var/i in 1 to length(from_turfs))
		var/turf/source = from_turfs[i]
		if(isnull(source))
			continue
		if(!(ordered_motion_flags[i] & GRID_MOVE_TURF))
			continue
		source.grid_clean(grid_flags, baseturf_boundary)
		CHECK_TICK

	return TRUE

//* Areas

/**
 * Called when collecting filtered turfs to move
 *
 * @return motion flags
 */
/area/proc/grid_collect(grid_flags, turf/old_turf, turf/new_turf, baseturf_boundary)
	return GRID_MOVE_AREA

/**
 * Called when copying area to new turfs
 */
/area/proc/grid_transfer(grid_flags, list/turf/old_turfs, list/turf/new_turfs, baseturf_boundary)
	contents += new_turfs

/**
 * Called when cleaning up after transfer
 */
/area/proc/grid_clean(grid_flags, list/turf/old_turfs, list/turf/new_turfs, baseturf_boundary, area/leave_area)
	contents -= old_turfs
	if(ispath(leave_area))
		leave_area = cached_area_of_type(leave_area)
	else if(istype(leave_area))
	else
		leave_area = cached_area_of_type[/area/space]
	leave_area.contents += old_turfs

/**
 * Called after everything is moved
 */
/area/proc/grid_after(grid_flags, list/turf/old_turfs, list/turf/new_turfs, baseturf_boundary)
	return

//* Turfs

/**
 * Called when collecting filtered turfs to move
 *
 * @return motion flags
 */
/turf/proc/grid_collect(grid_flags, turf/new_turf, baseturf_boundary, area_opinion)
	#warn impl

/**
 * Called when copying over to new turf
 * Only called if moved
 */
/turf/proc/grid_transfer(grid_flags, turf/new_turf, baseturf_boundary)
	#warn impl

/**
 * Called when cleaning up after transfer
 * Only called if moved
 */
/turf/proc/grid_clean(grid_flags, baseturf_boundary)
	#warn impl

/**
 * Called after everything settles
 */
/turf/proc/grid_after(grid_flags, rotation_angle)
	if(rotation_angle != 0)
		setDir(turn(dir, rotation_angle))

//* Movables

/**
 * Called when collecting filtered turfs to move
 *
 * @return motion flags
 */
/atom/movable/proc/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	return loc_opinion

/**
 * Called when moving to new position
 * Only called if moved
 */
/atom/movable/proc/grid_move(grid_flags, turf/new_turf)
	loc = new_turf

/**
 * Called after everything settles, after area/turf moved
 * Only called if moved
 */
/atom/movable/proc/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	if(rotation_angle != 0)
		setDir(turn(dir, rotation_angle))

/**
 * Called if we got added to late_call_hooks in grid_after.
 */
/atom/movable/proc/grid_finished(grid_flags, rotation_angle)
	return
