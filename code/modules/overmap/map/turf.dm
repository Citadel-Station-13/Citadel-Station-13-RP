
/area/overmap
	name = "System Map"
	icon_state = "start"
	area_power_override = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/turf/overmap
	icon = 'icons/turf/space.dmi'
	icon_state = "map"
	permit_ao = FALSE
//	initialized = FALSE	// TODO - Fix unsimulated turf initialization so this override is not necessary!

/turf/overmap/edge
	opacity = TRUE
	density = TRUE
	var/map_is_to_my
	var/turf/overmap/edge/wrap_buddy

/turf/overmap/edge/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/overmap/edge/LateInitialize()
	//This could be done by using the (LEGACY_MAP_DATUM).overmap_size much faster, HOWEVER, doing it programatically to 'find'
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

/turf/overmap/Initialize(mapload)
	. = ..()
	name = "[x]-[y]"
	var/list/numbers = list()

	if(x == 1 || x == (LEGACY_MAP_DATUM).overmap_size)
		numbers += list("[round(y/10)]","[round(y%10)]")
		if(y == 1 || y == (LEGACY_MAP_DATUM).overmap_size)
			numbers += "-"
	if(y == 1 || y == (LEGACY_MAP_DATUM).overmap_size)
		numbers += list("[round(x/10)]","[round(x%10)]")

	for(var/i = 1 to numbers.len)
		var/image/I = image('icons/effects/numbers.dmi',numbers[i])
		I.pixel_x = 5*i - 2
		I.pixel_y = world.icon_size/2 - 3
		if(y == 1)
			I.pixel_y = 3
			I.pixel_x = 5*i + 4
		if(y == (LEGACY_MAP_DATUM).overmap_size)
			I.pixel_y = world.icon_size - 9
			I.pixel_x = 5*i + 4
		if(x == 1)
			I.pixel_x = 5*i - 2
		if(x == (LEGACY_MAP_DATUM).overmap_size)
			I.pixel_x = 5*i + 2
		add_overlay(I)

/turf/overmap/Entered(var/atom/movable/O, var/atom/oldloc)
	..()
	if(istype(O, /obj/overmap/entity/visitable/ship))
		GLOB.overmap_event_handler.on_turf_entered(src, O, oldloc)

/turf/overmap/Exited(var/atom/movable/O, var/atom/newloc)
	..()
	if(istype(O, /obj/overmap/entity/visitable/ship))
		GLOB.overmap_event_handler.on_turf_exited(src, O, newloc)
