/turf/simulated/floor/water/river
	name = "shallow river"
	desc = "A moving body of water.  It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "seashallow" // So it shows up in the map editor as water.
	water_state = "rivershallow"
	water_file = 'icons/turf/river.dmi'
	under_state = "desert"
	var/delta_sum = 0
	var/float_delay = 10
	var/moving_dir = SOUTH

/turf/simulated/floor/water/river/update_icon()
	switch(moving_dir)
		if(NORTH)
			water_state = initial(water_state) + "_north"
		if(SOUTH)
			water_state = initial(water_state) + "_south"
		if(EAST)
			water_state = initial(water_state) + "_east"
		if(WEST)
			water_state = initial(water_state) + "_west"
		else
			message_admins("[src.type] ([src.x];[src.y];[src.z]) without a properly set moving dir, defaulting to north.")
			moving_dir = NORTH
			water_state = initial(water_state) + "_north"
	. = ..()
CREATE_STANDARD_TURFS(/turf/simulated/floor/water/river/south)
/turf/simulated/floor/water/river/south
	dir = SOUTH
	moving_dir = SOUTH

CREATE_STANDARD_TURFS(/turf/simulated/floor/water/river/north)
/turf/simulated/floor/water/river/north
	dir = NORTH
	moving_dir = NORTH

CREATE_STANDARD_TURFS(/turf/simulated/floor/water/river/east)
/turf/simulated/floor/water/river/east
	dir = EAST
	moving_dir = EAST

CREATE_STANDARD_TURFS(/turf/simulated/floor/water/river/west)
/turf/simulated/floor/water/river/west
	dir = WEST
	moving_dir = WEST

/turf/simulated/floor/water/river/deep
	name = "deep river"
	desc = "A deep moving body of water. Walking through this is gonna be a pain."
	icon_state = "seadeep"
	water_state = "riverdeep"
	under_state = "abyss"
	slowdown = 8
	depth = 2

CREATE_STANDARD_TURFS(/turf/simulated/floor/water/river/deep/south)
/turf/simulated/floor/water/river/deep/south
	dir = SOUTH
	moving_dir = SOUTH

CREATE_STANDARD_TURFS(/turf/simulated/floor/water/river/deep/north)
/turf/simulated/floor/water/river/deep/north
	dir = NORTH
	moving_dir = NORTH

CREATE_STANDARD_TURFS(/turf/simulated/floor/water/river/deep/east)
/turf/simulated/floor/water/river/deep/east
	dir = EAST
	moving_dir = EAST

CREATE_STANDARD_TURFS(/turf/simulated/floor/water/river/deep/west)
/turf/simulated/floor/water/river/deep/west
	dir = WEST
	moving_dir = WEST

/turf/simulated/floor/water/river/Entered(atom/movable/AM, atom/oldloc)
	. = ..()
	START_PROCESSING(SSobj, src)

/turf/simulated/floor/water/river/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/turf/simulated/floor/water/river/process(delta_time)
	if(!LAZYLEN(contents))
		STOP_PROCESSING(SSobj, src)//Failsafe, no need to process if we dont have any contents
		return
	if(!((locate(/obj/item) in contents) ||	(locate(/obj/vehicle) in contents) || (locate(/mob/living) in contents)))
		STOP_PROCESSING(SSobj, src)
		return
	if(locate(/obj/structure/catwalk) in contents)
		return//Stop floating stuff down stream when there is a catwalk
	delta_sum += delta_time
	if(delta_sum > float_delay)
		addtimer(CALLBACK(src, PROC_REF(convey), src.contents), 1)
		delta_sum = 0
		float_delay = rand(5, 20)

/turf/simulated/floor/water/river/proc/convey(list/affecting)
	var/turf/T = get_step(src, moving_dir)
	if(!T)
		return
	var/list/to_move
	LAZYINITLIST(to_move)
	for(var/atom/movable/A in affecting)
		if(istype(A, /atom/movable/lighting_overlay))
			continue
		if(!(A.anchored || (A.atom_flags & ATOM_ABSTRACT)))
			if(A.loc == src) // prevents the object from being affected if it's not currently here.
				step(A,moving_dir)


/obj/effect/floor_decal/river_beach_edge
	name = "beach"
	icon = 'icons/turf/river.dmi'
	icon_state = "shore_overlay"
	layer = ABOVE_TURF_LAYER //So it showes above the water layer of rivers

/obj/effect/floor_decal/river_beach_corner_edge
	name = "beach corner"
	icon = 'icons/turf/river.dmi'
	icon_state = "shore_corner_overlay"
	layer = ABOVE_TURF_LAYER //So it showes above the water layer of rivers


