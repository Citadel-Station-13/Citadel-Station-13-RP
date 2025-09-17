//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * transition border but for turf reservations
 *
 * todo: multi-tile object support
 * todo: allow simulation of specific atmos instead of just RESERVED_TURF_TYPe
 */
/datum/component/reservation_border
	can_transfer = TRUE
	var/atom/movable/mirage_border/holder1
	var/atom/movable/mirage_border/holder2
	var/atom/movable/mirage_border/holder3
	var/range
	var/dir
	var/turf/paired
	/// do we render visuals?
	var/render = TRUE
	/// custom callback to call when something crosses us
	var/datum/callback/handler_callback

/datum/component/reservation_border/Initialize(range = 10, dir, render, turf/paired, datum/callback/handler_callback)
	if(!isturf(parent))
		return COMPONENT_INCOMPATIBLE
	if(!dir || range < 1)
		. = COMPONENT_INCOMPATIBLE
		CRASH("[type] improperly instanced with the following args: direction=\[[dir]\], range=\[[range]\]")
	if(range > world.maxx || range > world.maxy || range > 20)
		. = COMPONENT_INCOMPATIBLE
		CRASH("[range] is too big a range. Max: 20, or the smallest dimension of the world.")
	src.range = range
	src.dir = dir
	src.handler_callback = handler_callback
	src.paired = paired
	if(!isnull(render))
		src.render = render

/datum/component/reservation_border/RegisterWithParent()
	. = ..()
	var/turf/T = parent
	T.set_opacity(TRUE)
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(transit))
	rebuild()

/datum/component/reservation_border/UnregisterFromParent()
	var/turf/T = parent
	T.set_opacity(FALSE)
	UnregisterSignal(parent, COMSIG_ATOM_ENTERED)
	QDEL_NULL(holder1)
	QDEL_NULL(holder2)
	QDEL_NULL(holder3)
	return ..()

/datum/component/reservation_border/proc/transit(datum/source, atom/movable/AM)
	if(AM.atom_flags & ATOM_ABSTRACT)
		return // nah.
	var/turf/our_turf = parent
	var/z_index = our_turf.z
	if(isnull(z_index))
		STACK_TRACE("no z index?! deleting self.")
		qdel(src)
		return
	// todo: this is shit but we have to yield to prevent a Moved() before Moved()
	spawn(0)
		if(AM.loc != our_turf)
			return
		if(handler_callback)
			handler_callback.Invoke(AM)
		if(AM.loc == our_turf)
			var/turf/target = paired
			AM.locationTransitForceMove(target, recurse_levels = 2)

/datum/component/reservation_border/proc/rebuild()
	// reset first
	holder1?.reset()
	holder2?.reset()
	holder3?.reset()

	// "why the hell do you need 3 holders"
	// because otherwise i can't offset them right, because we want the map to look like it's continuous, not overlapping
	// i hate byond!

	if(ISDIAGONALDIR(dir))
		// 1 is NS
		// 2 is EW
		// 3 is diag
		var/list/turfs

		turfs = turfs_in_cardinal(NSCOMPONENT(dir))
		if(length(turfs))
			if(!holder1)
				holder1 = new(parent)
			holder1.vis_contents = turfs
			holder1.pixel_y = dir & SOUTH? -world.icon_size * (range - 1) : 0

		turfs = turfs_in_cardinal(EWCOMPONENT(dir))
		if(length(turfs))
			if(!holder2)
				holder2 = new(parent)
			holder2.vis_contents = turfs
			holder2.pixel_x = dir & WEST? -world.icon_size * (range - 1) : 0

		turfs = turfs_in_diagonal(dir)
		if(length(turfs))
			if(!holder3)
				holder3 = new(parent)
			holder3.vis_contents = turfs
			holder3.pixel_y = dir & SOUTH? -world.icon_size * (range - 1) : 0
			holder3.pixel_x = dir & WEST? -world.icon_size * (range - 1) : 0
	else
		var/list/turfs = turfs_in_cardinal(dir)
		if(!length(turfs))
			return
		if(!holder1)
			holder1 = new(parent)
		holder1.vis_contents = turfs
		holder1.pixel_x = dir == WEST? -world.icon_size * (range - 1) : 0
		holder1.pixel_y = dir == SOUTH? -world.icon_size * (range - 1) : 0

/datum/component/reservation_border/proc/turfs_in_diagonal(dir)
	switch(dir)
		if(NORTHWEST)
			return block(
				locate(paired.x - range + 1, paired.y, paired.z),
				locate(paired.x, paired.y + range - 1, paired.z),
			)
		if(NORTHEAST)
			return block(
				locate(paired.x, paired.y, paired.z),
				locate(paired.x + range - 1, paired.y + range - 1, paired.z),
			)
		if(SOUTHWEST)
			return block(
				locate(paired.x - range + 1, paired.y - range + 1, paired.z),
				locate(paired.x, paired.y, paired.z),
			)
		if(SOUTHEAST)
			return block(
				locate(paired.x, paired.y - range + 1, paired.z),
				locate(paired.x + range - 1, paired.y, paired.z),
			)
		else
			CRASH("what?")

/datum/component/reservation_border/proc/turfs_in_cardinal(dir)
	switch(dir)
		if(NORTH)
			return block(
				paired,
				locate(paired.x, paired.y + range - 1, paired.z),
			)
		if(SOUTH)
			return block(
				locate(paired.x, paired.y - range + 1, paired.z),
				paired,
			)
		if(EAST)
			return block(
				paired,
				locate(paired.x + range - 1, paired.y, paired.z),
			)
		if(WEST)
			return block(
				locate(paired.x - range + 1, paired.y, paired.z),
				paired,
			)
		else
			CRASH("what?")
