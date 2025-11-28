//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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
 *
 * x2 must be the high value
 * y2 must be the high value
 *
 * We always sweep left to right, top to bottom, from the relative perspective of
 * looking towards the front of the shuttle's direction from the back.
 *
 * e.g. when NORTH, it's left to right, one line at a time from front to back.
 *
 * * If we are out of bounds of a level, we will end up emitting a list with nulls where there are no turfs!
 */
/datum/controller/subsystem/grids/proc/get_ordered_turfs(x1, x2, y1, y2, z, dir)
	ASSERT(x2 >= x1)
	ASSERT(y2 >= y1)
	. = list()
	switch(dir)
		if(NORTH)
			for(var/y in y2 to y1 step -1)
				for(var/x in x1 to x2 step 1)
					. += locate(x, y, z)
		if(SOUTH)
			for(var/y in y1 to y2 step 1)
				for(var/x in x2 to x1 step -1)
					. += locate(x, y, z)
		if(EAST)
			for(var/x in x2 to x1 step -1)
				for(var/y in y2 to y1 step -1)
					. += locate(x, y, z)
		if(WEST)
			for(var/x in x1 to x2 step 1)
				for(var/y in y1 to y2 step 1)
					. += locate(x, y, z)

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
 * Taking ordered 'from' and 'to' lists, nulls out any entries that shouldn't be moved.
 *
 * * turfs can contain nulls
 * * input turf lists are edited
 * * area_cache must have truthy associations.
 * * the same index in from_turfs that are nulled are nulled in to_turfs
 */
/datum/controller/subsystem/grids/proc/null_filter_translation_ordered_turfs_in_place_via_area(list/area/area_cache, list/turf/from_turfs, list/turf/to_turfs)
	ASSERT(length(from_turfs) == length(to_turfs))
	for(var/i in 1 to length(from_turfs))
		var/turf/T = from_turfs[i]
		if(area_cache[T.loc])
			continue
		from_turfs[i] = null
		to_turfs[i] = null

/**
 * Taking ordered turfs as a list, nulls out any entries that isn't in the areas given
 *
 * * turfs can contain nulls
 * * input turf list is edited
 * * area_cache must have truthy associations.
 */
/datum/controller/subsystem/grids/proc/null_filter_ordered_turfs_in_place_via_area(list/area/area_cache, list/turf/ordered_turfs)
	for(var/i in 1 to length(ordered_turfs))
		var/turf/T = ordered_turfs[i]
		if(area_cache[T.loc])
			continue
		ordered_turfs[i] = null

/**
 * Taking ordered 'from' and 'to' lists, erases any entries that shouldn't be moved.
 * preserves relative order
 *
 * * turfs can contain nulls
 * * input turf lists are edited
 * * area_cache must have truthy associations.
 */
/datum/controller/subsystem/grids/proc/filter_ordered_turfs_via_area(list/area/area_cache, list/turf/ordered_turfs)
	. = list()
	for(var/turf/T in ordered_turfs)
		if(!area_cache[T.loc])
			continue
		. += T

/**
 * performs turf translation
 *
 * baseturf boundary is important if you do not want things being ripped out of the ground.
 * without boundary set, turfs will be completely scraped down to their bottom baseturfs,
 * and destination turfs will have their baseturf stacks trampled by this.
 *
 * * from_turfs and to_turfs can have nulls, as long as they're in the same order.
 * * said null behavior is intentional, so that shuttles can easily perform turf filtering.
 *
 * @params
 * * from_turfs - get_ordered_turfs return list
 * * from_dir - dir of from_turfs
 * * to_turfs - get_ordered_turfs return list
 * * to_dir - dir of to_turfs
 * * grid_flags - flags to pass during move to motion procs
 * * baseturf_boundary - if set, turfs move down to this baseturf boundary. if it's not there, the turf is automatically skipped.
 * * leave_area - the area instance to leave behind. if not set, this defaults to world.area. this can be a typepath if the typepath is an unique area.
 * * emit_motion_flags - use this to extract ordered motion flags
 * * emit_moved_atoms - use this to extract what movables got moved
 * * turf_overlap_handler - bound proc that's fired for things in the way with (from_turf, to_turf); things: turfs. ATOM_ABSTRACT and ATOM_NONWORLD are ignored. Called before `movable_overlap_handler`.
 * * movable_overlap_handler - bound proc that's fired for things in the way with (thing, from_turf, to_turf); things: objs, mobs. ATOM_ABSTRACT and ATOM_NONWORLD are ignored.
 */
/datum/controller/subsystem/grids/proc/translate(list/from_turfs, list/to_turfs, from_dir, to_dir, grid_flags, baseturf_boundary, area/leave_area, list/emit_motion_flags = list(), list/emit_moved_atoms = list(), datum/bound_proc/turf_overlap_handler, datum/bound_proc/movable_overlap_handler)
	UNTIL(!translation_mutex)
	translation_mutex = TRUE
	. = do_translate(arglist(args))
	translation_mutex = FALSE

/datum/controller/subsystem/grids/proc/do_translate(list/from_turfs, list/to_turfs, from_dir, to_dir, grid_flags, baseturf_boundary, area/leave_area, list/emit_motion_flags, list/emit_moved_atoms, datum/bound_proc/turf_overlap_handler, datum/bound_proc/movable_overlap_handler)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// While based on /tg/'s movement system, we do a few things differently.
	// First, limitations:
	// * base-areas aren't a thing. Areas are flat out trampled on move. On takeoff, areas are reset.
	// * Turfs are assumed to be entirely described by baseturfs. So, flooring's just trampled too.
	// * Areas may be left behind if a bounding box doesn't completely envelop an area. There's not many ways to fix this, so make sure your bounding boxes do.
	// The actual process:
	// * Collect turfs, with order of opinions being area -> turf -> movable
	// * Move areas to their new turfs all at once
	// * Move turfs one by one, calling turf --> movable overlap handlers on that turf if needed.
	// * Move movables to their new turfs
	// * Proc grid_after() on all areas -> turfs -> movables in these stages
	// * Cleanup areas from their old turfs all at once
	// * Cleanup turfs one by onew
	// * Proc grid_finished() on all registered movables
	// Caveats / Pointers:
	// * rotation_angle is in turn() angles.
	// * none of these are tick checked right now. do not sleep,
	// * do not do anything expensive, async your calls or kick them elsewhere if they're expensive!

	. = FALSE

	ASSERT(length(from_turfs) == length(to_turfs))

	/// motion flags corrosponding to ordered turfs. this is ordered. null turf --> null.
	var/list/ordered_motion_flags = emit_motion_flags
	ordered_motion_flags.len = length(from_turfs)
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
		ordered_motion_flags[i] = motion_flags
		// if moving area, add to turfs_by_area
		if(motion_flags & GRID_MOVE_AREA)
			if(isnull(source_turfs_by_area[source_area]))
				source_turfs_by_area[source_area] = list(source)
				destination_turfs_by_area[source_area] = list(destination)
			else
				source_turfs_by_area[source_area] += source
				destination_turfs_by_area[source_area] += destination

	//* Transfer areas
	for(var/area/A as anything in source_turfs_by_area)
		A.grid_transfer(grid_flags, source_turfs_by_area[A], destination_turfs_by_area[A], baseturf_boundary)

	//* Transfer turfs
	for(var/i in 1 to length(from_turfs))
		var/turf/source = from_turfs[i]
		if(isnull(source))
			continue
		if(!(ordered_motion_flags[i] & GRID_MOVE_TURF))
			continue
		var/turf/destination = to_turfs[i]
		// -- fire overlap handlers --
		turf_overlap_handler?.invoke_async(source, destination)
		for(var/atom/movable/AM as anything in destination)
			if(AM.atom_flags & (ATOM_NONWORLD | ATOM_ABSTRACT))
				continue
			if(AM.handle_grid_overlap(grid_flags))
				continue
			movable_overlap_handler?.invoke_async(AM, source, destination)
		// -- end --
		source.grid_transfer(grid_flags, destination, baseturf_boundary)

	//* Move movables
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

	//* Cleanup turfs
	for(var/i in 1 to length(from_turfs))
		var/turf/source = from_turfs[i]
		if(isnull(source))
			continue
		if(!(ordered_motion_flags[i] & GRID_MOVE_TURF))
			continue
		source.grid_clean(grid_flags, baseturf_boundary)

	return TRUE

//* Debug Functions *//

/**
 * source/target specifiers can be turfs or lists
 */
/datum/controller/subsystem/grids/proc/debug_yeet_a_chunk(source_lower_left, source_top_right, target_lower_left, target_top_right, turn_angle = 0)
	var/list/S_LL
	var/list/S_TR
	var/list/T_LL
	var/list/T_TR

	if(isturf(source_lower_left))
		S_LL = list(source_lower_left:x, source_lower_left:y, source_lower_left:z)
	else
		S_LL = source_lower_left
	if(isturf(source_top_right))
		S_TR = list(source_top_right:x, source_top_right:y, source_top_right:z)
	else
		S_TR = source_top_right
	if(isturf(target_lower_left))
		T_LL = list(target_lower_left:x, target_lower_left:y, target_lower_left:z)
	else
		T_LL = target_lower_left
	if(isturf(target_top_right))
		T_TR = list(target_top_right:x, target_top_right:y, target_top_right:z)
	else
		T_TR = target_top_right

	var/list/from_turfs = get_ordered_turfs(S_LL[1], S_TR[1], S_LL[2], S_TR[2], S_LL[3], SOUTH)
	var/list/to_turfs = get_ordered_turfs(T_LL[1], T_TR[1], T_LL[2], T_TR[2], T_LL[3], turn(SOUTH, turn_angle))

	ASSERT(length(from_turfs) == length(to_turfs))

	translate(from_turfs, to_turfs, SOUTH, turn(SOUTH, turn_angle))

//* Areas

/**
 * Called when collecting filtered turfs to move
 *
 * @return motion flags
 */
/area/proc/grid_collect(grid_flags, turf/old_turf, turf/new_turf, baseturf_boundary)
	SHOULD_NOT_SLEEP(TRUE)
	return GRID_MOVE_AREA

/**
 * Called when copying area to new turfs
 */
/area/proc/grid_transfer(grid_flags, list/turf/old_turfs, list/turf/new_turfs, baseturf_boundary)
	SHOULD_NOT_SLEEP(TRUE)
	take_turfs(new_turfs)

/**
 * Called when cleaning up after transfer
 */
/area/proc/grid_clean(grid_flags, list/turf/old_turfs, list/turf/new_turfs, baseturf_boundary, area/leave_area)
	SHOULD_NOT_SLEEP(TRUE)
	// contents -= old_turfs
	if(ispath(leave_area))
		leave_area = dynamic_area_of_type(leave_area)
	else if(istype(leave_area))
	else
		leave_area = dynamic_area_of_type(world.area)
	if(isnull(leave_area))
		leave_area = new /area/grid_orphaned
	leave_area.take_turfs(old_turfs)

/**
 * Called after everything is moved
 */
/area/proc/grid_after(grid_flags, list/turf/old_turfs, list/turf/new_turfs, baseturf_boundary)
	SHOULD_NOT_SLEEP(TRUE)
	return

//* Turfs

/**
 * Called when collecting filtered turfs to move
 *
 * @return motion flags
 */
/turf/proc/grid_collect(grid_flags, turf/new_turf, baseturf_boundary, area_opinion)
	SHOULD_NOT_SLEEP(TRUE)
	if(isnull(baseturf_boundary))
		return area_opinion | GRID_MOVE_TURF | GRID_MOVE_MOVABLES
	if(baseturf_boundary in baseturfs)
		return area_opinion | GRID_MOVE_TURF | GRID_MOVE_MOVABLES
	return area_opinion

/**
 * Called when copying over to new turf
 * Only called if moved
 */
/turf/proc/grid_transfer(grid_flags, turf/new_turf, baseturf_boundary)
	SHOULD_NOT_SLEEP(TRUE)
	if(isnull(baseturf_boundary))
		new_turf.CopyOnTop(src, null, null, CHANGETURF_INHERIT_AIR)
	else
		new_turf.CopyOnTop(src, 1, length(baseturfs) - baseturfs.Find(baseturf_boundary) + 1, CHANGETURF_INHERIT_AIR)

/**
 * Called when cleaning up after transfer
 * Only called if moved
 */
/turf/proc/grid_clean(grid_flags, baseturf_boundary)
	SHOULD_NOT_SLEEP(TRUE)
	if(isnull(baseturf_boundary))
		// tear to the bottom
		ChangeTurf(baseturf_bottom(), /turf/baseturf_bottom)
	else
		// tear down to below boundary
		var/tear_to_index = baseturfs.Find(baseturf_boundary)
		ScrapeAway(length(baseturfs) - tear_to_index + 1)

/**
 * Called after everything settles
 */
/turf/proc/grid_after(grid_flags, rotation_angle)
	SHOULD_NOT_SLEEP(TRUE)
	if(rotation_angle != 0)
		setDir(turn(dir, rotation_angle))

//* Movables

/**
 * Called when collecting filtered turfs to move
 *
 * @return motion flags
 */
/atom/movable/proc/grid_collect(grid_flags, turf/new_turf, loc_opinion)
	SHOULD_NOT_SLEEP(TRUE)
	return loc_opinion

/**
 * Called when moving to new position
 * Only called if moved
 */
/atom/movable/proc/grid_move(grid_flags, turf/new_turf)
	SHOULD_NOT_SLEEP(TRUE)
	abstract_move(new_turf)

/**
 * Called after everything settles, after area/turf moved
 * Only called if moved
 */
/atom/movable/proc/grid_after(grid_flags, rotation_angle, list/late_call_hooks)
	SHOULD_NOT_SLEEP(TRUE)
	if(rotation_angle != 0)
		setDir(turn(dir, rotation_angle))

/**
 * Called if we got added to late_call_hooks in grid_after.
 */
/atom/movable/proc/grid_finished(grid_flags, rotation_angle)
	SHOULD_NOT_SLEEP(TRUE)
	return

/**
 * called when we get overlapped by a grid
 *
 * we can be overlapped if non-ABSTRACT.
 *
 * @return TRUE to override overlap_handler callback.
 */
/atom/movable/proc/handle_grid_overlap(grid_flags)
	SHOULD_NOT_SLEEP(TRUE)
	return FALSE

//* grid area left behind if a grid move is not given an area to leave *//

/area/grid_orphaned
	name = "orphaned grid area"
	desc = "someone fucked up"
	icon = 'icons/turf/area/debug.dmi'
	icon_state = "grid-orphan"
	plane = DEBUG_PLANE
	layer = DEBUG_LAYER_AREA_OVERLAYS
