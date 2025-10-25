//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Component used for turf transitions.
 *
 * How it works is, the outermost turf on z-levels is actually
 * the second from the edge turf on the adjacent z-level.
 *
 * This way, we have *near* perfect native-like simulation with moves without
 * having to do anything too special.
 *
 * todo: multi-tile object support
 */
/datum/component/transition_border
	var/atom/movable/mirage_border/holder1
	var/atom/movable/mirage_border/holder2
	var/atom/movable/mirage_border/holder3
	var/range
	var/dir
	/// do we render visuals?
	var/render = TRUE

/datum/component/transition_border/Initialize(range = 10, dir, render)
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
	if(!isnull(render))
		src.render = render

/datum/component/transition_border/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(transit))
	rebuild()

/datum/component/transition_border/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_ENTERED)
	QDEL_NULL(holder1)
	QDEL_NULL(holder2)
	QDEL_NULL(holder3)
	return ..()

/datum/component/transition_border/proc/transit(datum/source, atom/movable/AM)
	if(AM.atom_flags & ATOM_ABSTRACT)
		return // nah.
	if(AM.movable_flags & MOVABLE_IN_MOVED_YANK)
		return // we're already in a yank
	var/turf/our_turf = parent
	var/z_index = SSmapping.level_get_index_in_dir(our_turf.z, dir)
	if(isnull(z_index))
		STACK_TRACE("no z index?! deleting self.")
		qdel(src)
		return
	// todo: this is shit but we have to yield to prevent a Moved() before Moved()
	AM.movable_flags |= MOVABLE_IN_MOVED_YANK
	spawn(0)
		AM.movable_flags &= ~MOVABLE_IN_MOVED_YANK
		if(AM.loc != our_turf)
			return
		var/turf/target
		switch(dir)
			if(NORTH)
				target = locate(our_turf.x, 2, z_index)
			if(SOUTH)
				target = locate(our_turf.x, world.maxy - 1, z_index)
			if(EAST)
				target = locate(2, our_turf.y, z_index)
			if(WEST)
				target = locate(world.maxx - 1, our_turf.y, z_index)
			if(NORTHEAST)
				target = locate(2, 2, z_index)
			if(NORTHWEST)
				target = locate(world.maxx - 1, 2, z_index)
			if(SOUTHEAST)
				target = locate(2, world.maxy - 1, z_index)
			if(SOUTHWEST)
				target = locate(world.maxx - 1, world.maxy - 1, z_index)
		AM.locationTransitForceMove(target, recurse_levels = 2)

/datum/component/transition_border/proc/rebuild()
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

/datum/component/transition_border/proc/turfs_in_diagonal(dir)
	ASSERT(dir & (dir - 1))
	var/turf/our_turf = parent
	var/datum/map_level/our_level = SSmapping.ordered_levels[our_turf.z]
	if(isnull(our_level))
		return list()
	var/datum/map_level/target_level = our_level.get_level_in_dir(dir)
	if(isnull(target_level))
		return list()
	switch(dir)
		if(NORTHWEST)
			return block(
				locate(world.maxx - 1, 2, target_level.z_index),
				locate(world.maxx - 1 - range + 1, 2 + range - 1, target_level.z_index),
			)
		if(NORTHEAST)
			return block(
				locate(2, 2, target_level.z_index),
				locate(2, 2 + range - 1, target_level.z_index),
			)
		if(SOUTHWEST)
			return block(
				locate(world.maxx - 1, world.maxy - 1, target_level.z_index),
				locate(world.maxx - 1 - range + 1, world.maxy - 1 - range + 1, target_level.z_index),
			)
		if(SOUTHEAST)
			return block(
				locate(2, world.maxy - 1, target_level.z_index),
				locate(2 + range - 1, world.maxy - 1 - range + 1, target_level.z_index),
			)
		else
			CRASH("what?")

/datum/component/transition_border/proc/turfs_in_cardinal(dir)
	var/turf/our_turf = parent
	var/datum/map_level/our_level = SSmapping.ordered_levels[our_turf.z]
	if(isnull(our_level))
		return list()
	var/datum/map_level/target_level = our_level.get_level_in_dir(dir)
	if(isnull(target_level))
		return list()
	switch(dir)
		if(NORTH)
			return block(
				locate(our_turf.x, 2, target_level.z_index),
				locate(our_turf.x, 2 + range - 1, target_level.z_index),
			)
		if(SOUTH)
			return block(
				locate(our_turf.x, world.maxy - 1, target_level.z_index),
				locate(our_turf.x, world.maxy - 1 - range + 1, target_level.z_index),
			)
		if(EAST)
			return block(
				locate(2, our_turf.y, target_level.z_index),
				locate(2 + range - 1, our_turf.y, target_level.z_index),
			)
		if(WEST)
			return block(
				locate(world.maxx - 1, our_turf.y, target_level.z_index),
				locate(world.maxx - 1 - range + 1, our_turf.y, target_level.z_index),
			)
		else
			CRASH("what?")

/**
 * makes us into a level border, which changeturfs us if we aren't already a /turf/level_border
 */
/turf/proc/_make_transition_border(dir, render = TRUE)
	var/turf/T = src
	if(!istype(T, /turf/level_border))
		T = PlaceOnTop(/turf/level_border)
	if(isnull(SSmapping.level_get_index_in_dir(z, dir)))
		return
	var/datum/component/transition_border/border = T.GetComponent(/datum/component/transition_border)
	if(border)
		qdel(border)
	T.AddComponent(/datum/component/transition_border, dir = dir, render = render)

/**
 * clears us from being a level border, which scrapes us away if we're a /turf/level_border
 */
/turf/proc/_dispose_transition_border()
	var/turf/T = src
	if(istype(T, /turf/level_border))
		T = ScrapeAway(1)
	var/datum/component/transition_border/border = T.GetComponent(/datum/component/transition_border)
	if(!isnull(border))
		qdel(border)
		return TRUE
	return FALSE

/atom/movable/mirage_border
	name = "Mirage holder"
	anchored = TRUE
	plane = SPACE_PLANE
	density = FALSE
	atom_flags = ATOM_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_HIDE	// THIS IS VERY FUCKING IMPORTANT; WILL CRASH SERVER IF IT LOOPS.

/atom/movable/mirage_border/Destroy()
	. = ..()
	if(. == QDEL_HINT_LETMELIVE)
		return
	// forcefully move, doMove is overridden
	loc = null

/atom/movable/mirage_border/doMove(atom/destination)
	return FALSE

/atom/movable/mirage_border/proc/reset()
	pixel_x = 0
	pixel_y = 0
	vis_contents.len = 0

/atom/movable/mirage_border/vv_edit_var(var_name, var_value, raw_edit)
	if(var_value == NAMEOF(src, vis_flags))	// NO
		return FALSE
	return ..()

/**
 * borders at the edge of zlevels
 */
CREATE_STANDARD_TURFS(/turf/level_border)
/turf/level_border
	name = "level border"
	desc = "You shouldn't see this."
	invisibility = 101
	icon = null
	icon_state = null
	plane = SPACE_PLANE
	vis_flags = VIS_HIDE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	density = FALSE
	initial_gas_mix = ATMOSPHERE_USE_OUTDOORS
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	// so the fullbright overlay doesn't cause issues on the other side
	lighting_disable_fullbright = TRUE

// todo: refactor
/turf/level_border/Initialize(mapload)
	. = ..()
	SSplanets.addWall(src)

/turf/level_border/Destroy()
	SSplanets.removeWall(src)
	return ..()

//? Sector API

/turf/level_border/sector_set_temperature(temperature)
	if(temperature == src.temperature)
		return
	src.temperature = temperature
	// Force ZAS to reconsider our connections because our temperature has changed
	if(connections)
		connections.erase_all()
	queue_zone_update()
