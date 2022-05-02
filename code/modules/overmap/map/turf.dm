/turf/overmap
	plane = OVEMRAP_PLANE
	#warn move to icons/overmap
	icon = 'icons/turf/space.dmi'
	icon_state = "map"
	plane = OVERMAP_PLANE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	/// we are always lit, we use our own lighting system
	luminosity = 1

	#warn lighting overlay
	var/static/image/lighting_blackness
	/// vis holder
	var/atom/movable/overmap_visual_holder/vis_holder

/turf/overmap/Initialize()
	. = ..()
	#warn how do we visualize coords
	name = "[x]-[y]"
	var/list/numbers = list()

	if(x == 1 || x == GLOB.using_map.overmap_size)
		numbers += list("[round(y/10)]","[round(y%10)]")
		if(y == 1 || y == GLOB.using_map.overmap_size)
			numbers += "-"
	if(y == 1 || y == GLOB.using_map.overmap_size)
		numbers += list("[round(x/10)]","[round(x%10)]")

	for(var/i = 1 to numbers.len)
		var/image/I = image('icons/effects/numbers.dmi',numbers[i])
		I.pixel_x = 5*i - 2
		I.pixel_y = world.icon_size/2 - 3
		if(y == 1)
			I.pixel_y = 3
			I.pixel_x = 5*i + 4
		if(y == GLOB.using_map.overmap_size)
			I.pixel_y = world.icon_size - 9
			I.pixel_x = 5*i + 4
		if(x == 1)
			I.pixel_x = 5*i - 2
		if(x == GLOB.using_map.overmap_size)
			I.pixel_x = 5*i + 2
		add_overlay(I)

	// add lighting overlay
	add_overlay(lighting_blackness)

/turf/overmap/Destroy()
	cut_overlay(lighting_blackness)
	if(vis_holder)
		QDEL_NULL(vis_holder)
	vis_locs.Cut()
	return ..()

/turf/overmap/Entered(var/atom/movable/O, var/atom/oldloc)
	..()
	if(istype(O, /atom/movable/overmap_object/entity/visitable/ship))
		GLOB.overmap_event_handler.on_turf_entered(src, O, oldloc)

/turf/overmap/Exited(var/atom/movable/O, var/atom/newloc)
	..()
	if(istype(O, /atom/movable/overmap_object/entity/visitable/ship))
		GLOB.overmap_event_handler.on_turf_exited(src, O, newloc)

/turf/overmap/edge
	opacity = 1
	density = 1
	var/map_is_to_my
	var/turf/overmap/edge/wrap_buddy

/turf/overmap/edge/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/overmap/edge/LateInitialize()
	//This could be done by using the GLOB.using_map.overmap_size much faster, HOWEVER, doing it programatically to 'find'
	//  the edges this way allows for 'sub overmaps' elsewhere and whatnot.
	for(var/side in GLOB.alldirs) //The order of this list is relevant: It should definitely break on finding a cardinal FIRST.
		var/turf/T = get_step(src, side)
		if(T?.type == /turf/overmap) //Not a wall, not something else, EXACTLY a flat map turf.
			map_is_to_my = side
			break

	if(map_is_to_my)
		var/turf/T = get_step(src, map_is_to_my)	// Should be a normal map turf
		while(istype(T, /turf/overmap))
			T = get_step(T, map_is_to_my)	// Could be a wall if the map is only 1 turf big
			if(istype(T, /turf/overmap/edge))
				wrap_buddy = T
				break

/turf/overmap/edge/Destroy()
	wrap_buddy = null
	return ..()

/turf/overmap/edge/Bumped(var/atom/movable/AM)
	if(wrap_buddy?.map_is_to_my)
		AM.forceMove(get_step(wrap_buddy, wrap_buddy.map_is_to_my))
	else
		. = ..()

/**
 * separates us from rest of space reservations
 */
/turf/overmap/border
	name = ""
	desc = ""
	icon_state = ""
	opacity = TRUE
	density = TRUE

/**
 * visual holder
 */
/atom/movable/overmap_visual_holder

/atom/movable/overmap_visual_holder/Initialize(mapload)
	// highlander - kill existing
	if(istype(loc, /turf/overmap))
		var/turf/overmap/T = loc
		if(T.vis_holder)
			qdel(T.vis_holder)
		T.vis_holder = src
	return ..()

/atom/movable/overmap_visual_holder/Destroy()
	vis_contents.Cut()
	return ..()
