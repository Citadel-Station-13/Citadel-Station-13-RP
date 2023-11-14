//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Component used for turf transitions.
 */
/datum/component/transition_border
	can_transfer = TRUE
	var/atom/movable/mirage_border/holder1
	var/atom/movable/mirage_border/holder2
	var/atom/movable/mirage_border/holder3
	var/range
	var/dir
	/// do we render visuals?
	var/render = TRUE
	/// if set, "grab other z turfs" always goes to this level
	var/force_target
	/// if set, transition handling always goes to this turf
	var/turf/force_destination

#warn deal with
#warn this is shitcode upon shitcode
#warn rewrite this as well as levels to do this faster.
#warn verify transfer code

/datum/component/transition_border/Initialize(range = TRANSITION_VISUAL_SIZE, dir, render, force_z_target, force_destination)
	if(!isturf(parent))
		return COMPONENT_INCOMPATIBLE
	if(!dir || range < 1)
		. = COMPONENT_INCOMPATIBLE
		CRASH("[type] improperly instanced with the following args: direction=\[[dir]\], range=\[[range]\]")
	if(range > world.maxx || range > world.maxy || range > 20)
		. = COMPONENT_INCOMPATIBLE
		CRASH("[range] is too big a range. Max: 20, or the smallest dimension of hte world..")
	src.range = range
	src.dir = dir
	if(!isnull(force_z_target))
		src.force_target = force_z_target
	if(!isnull(render))
		src.render = render
	if(!isnull(force_destination))
		src.force_destination = force_destination

/datum/component/transition_border/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, .proc/transit)
	Build()

/datum/component/transition_border/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_ENTERED)
	QDEL_NULL(holder1)
	QDEL_NULL(holder2)
	QDEL_NULL(holder3)
	return ..()

/datum/component/transition_border/proc/transit(datum/source, atom/movable/AM)
	var/turf/destination = SSmapping.GetVirtualStep(parent, dir)
	if(!destination)
		CRASH("Invalid destination found??")
	AM.locationTransitForceMove(destination, 2)

/datum/component/transition_border/proc/Build()
	// reset first
	holder1?.reset()
	holder2?.reset()
	holder3?.reset()

	#warn can avoid needing 2-2 spacing and have 1-1 spacing
	#warn where first tile from edge teleports to second tile from edge
	#warn using VIS_HIDE.

	// "why the hell do you need 3 holders"
	// because otherwise i can't offset them right, because we want the map to look like it's continuous, not overlapping
	// i hate byond!

	if(dir & (dir - 1))
		// 1 is NS
		// 2 is EW
		// 3 is diag
		var/list/turfs

		turfs = GetTurfsInCardinal(NSCOMPONENT(dir))
		if(length(turfs))
			if(!holder1)
				holder1 = new(parent)
			holder1.vis_contents = turfs
			holder1.pixel_y = dir & SOUTH? -world.icon_size * (range - 1) : 0

		turfs = GetTurfsInCardinal(EWCOMPONENT(dir))
		if(length(turfs))
			if(!holder2)
				holder2 = new(parent)
			holder2.vis_contents = turfs
			holder2.pixel_x = dir & WEST? world.icon_size * (range - 1) : 0

		turfs = GetTurfsInDiagonal(dir)
		if(length(turfs))
			if(!holder3)
				holder3 = new(parent)
			holder3.vis_contents = turfs
			holder3.pixel_y = dir & SOUTH? world.icon_size * (range - 1) : 0
			holder3.pixel_x = dir & WEST? world.icon_size * (range - 1) : 0
	else
		var/list/turfs = GetTurfsInCardinal(dir)
		if(!length(turfs))
			return
		if(!holder1)
			holder1 = new(parent)
		holder1.vis_contents = turfs
		holder1.pixel_x = dir == WEST? world.icon_size * (range - 1) : 0
		holder1.pixel_y = dir == SOUTH? world.icon_size * (range - 1) : 0

/datum/component/transition_border/proc/GetTurfsInDiagonal(dir)
	#warn support less-than-world-size levels
	ASSERT(dir & (dir - 1))
	var/turf/T = parent
	var/datum/space_level/L = SSmapping.ordered_levels[T.z]
	var/datum/space_level/target_level = isnull(force_target) && L.resolve_level_in_dir(dir)
	if(!target_level && !force_target)
		return list()
	var/turf/target = locate(
		dir & EAST? 2 : 254,
		dir & NORTH? 2 : 254,
		target_level.z_value
	)
	return block(
		target,
		locate(
			dir & EAST? range + 1 : world.maxx - range,
			dir & NORTH? range + 1 : world.maxy - range,
			force_target || target_level.z_value
		)
	)

/datum/component/transition_border/proc/GetTurfsInCardinal(dir)
	#warn support less-than-world-size levels
	// ASSERT(dir)
	var/turf/T = parent
	var/datum/space_level/L = SSmapping.ordered_levels[T.z]
	var/datum/space_level/target_level = isnull(force_target) && L.resolve_level_in_dir(dir)
	if(!target_level && !force_target)
		return list()

	var/turf/target = locate((dir == EAST)? 2 : ((dir == WEST)? world.maxx - 1 : T.x), (dir == NORTH)? 2 : ((dir == SOUTH)? world.maxy - 1 : T.y), force_target || target_level.z_value)
	return block(
		target,
		locate(
			(dir == EAST)? range + 1 : ((dir == WEST)? world.maxx - range : T.x),
			(dir == NORTH)? range + 1 : ((dir == SOUTH)? world.maxy - range : T.y),
			force_target || target_level.z_value
		)
	)

/**
 * makes us into a level border, which changeturfs us if we aren't already a /turf/level_border
 */
/turf/proc/_make_transition_border(dir, render = TRUE)
	var/turf/T = src
	if(!istype(T, /turf/level_border))
		T = PlaceOnTop(/turf/level_border)
	var/datum/component/transition_border/border = T.GetComponent(/datum/component/transition_border)
	if(border)
		qdel(border)
	T.AddComponent(/datum/component/transition_border, TRANSITION_VISUAL_RANGE, dir, render)

/**
 * clears us from being a level border, which scrapes us away if we're a /turf/level_border
 */
/turf/proc/_dispose_transition_border()
	var/turf/T = src
	if(istype(T, /turf/level_border))
		T = ScrapeAway(1)
	var/datum/component/transition_border/border = T.GetComponent(/datum/component/transition_border)
	if(border)
		qdel(border)
	return !!border

/atom/movable/mirage_border
	name = "Mirage holder"
	anchored = TRUE
	plane = SPACE_PLANE
	density = FALSE
	atom_flags = ATOM_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_HIDE	// THIS IS VERY FUCKING IMPORTANT; WILL CRASH SERVER IF IT LOOPS.

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
