
/turf/overmap
	icon = 'icons/turf/space.dmi'
	icon_state = "map"
	permit_ao = FALSE
//	initialized = FALSE	// TODO - Fix unsimulated turf initialization so this override is not necessary!

/turf/overmap/map
	#warn impl

/turf/overmap/edge
	opacity = TRUE
	density = TRUE

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
