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

/turf/simulated/floor/water/river/deep
	name = "deep river"
	desc = "A deep moving body of water. Walking through this is gonna be a pain."
	water_state = "riverdeep"
	under_state = "abyss"
	slowdown = 8
	depth = 2

/turf/simulated/floor/water/river/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/turf/simulated/floor/water/river/process(delta_time)
	delta_sum += delta_time
	if(delta_sum > float_delay)
		convey(contents)
		delta_sum = 0
		float_delay = rand(5, 20)

/turf/simulated/floor/water/river/proc/convey(list/affecting)
	var/turf/T = get_step(src, dir)
	if(!T)
		return
	affecting.len = max(min(affecting.len, 150 - T.contents.len), 0)
	if(!affecting.len)
		return
	var/items_moved = 0
	for(var/atom/movable/A in affecting)
		if(!A.anchored)
			if(A.loc == src.loc) // prevents the object from being affected if it's not currently here.
				step(A,dir)
				++items_moved
		if(items_moved >= 50)
			break

/obj/effect/floor_decal/river_beach_edge
	name = "beach"
	icon = 'icons/turf/river.dmi'
	icon_state = "shore_overlay"

/obj/effect/floor_decal/river_beach_corner_edge
	name = "beach corner"
	icon = 'icons/turf/river.dmi'
	icon_state = "shore_corner_overlay"
