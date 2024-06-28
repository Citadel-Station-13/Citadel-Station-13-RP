
/turf/overmap
	name = "--init--"
	desc = "If you see this, it means coders didn't update the description but did allow perspective-relayed examine. Yell at them."
	icon = 'icons/turf/space.dmi'
	icon_state = "map"
	permit_ao = FALSE

	maptext_width = 32
	maptext_y = 12

/turf/overmap/proc/initialize_overmap(datum/overmap/map)
	return

/turf/overmap/map
	opacity = FALSE
	density = FALSE
	#warn impl

/turf/overmap/map/initialize_overmap(datum/overmap/map)
	var/calculated_x = x - map.lower_left_x
	var/calculated_y = y - map.lower_left_y
	name = "[calculated_x]-[calculated_y]"

/turf/overmap/edge
	opacity = TRUE
	density = TRUE
	#warn impl

/turf/overmap/edge/initialize_overmap(datum/overmap/map)
	name = "border (warp-enabled)"
	var/number
	if(x == map.lower_left_x - 1 || x == map.upper_right_x)
		// left or right borders
		number = y - map.lower_left_y
	else if(y == map.lower_left_y - 1 || y == map.upper_right_y + 1)
		// top or bottom borders
		number = x - map.lower_left_x

	maptext = MAPTEXT("[number]")

//! LEGACY BELOW

/turf/overmap/Entered(var/atom/movable/O, var/atom/oldloc)
	..()
	if(istype(O, /obj/overmap/entity/visitable/ship))
		GLOB.overmap_event_handler.on_turf_entered(src, O, oldloc)

/turf/overmap/Exited(var/atom/movable/O, var/atom/newloc)
	..()
	if(istype(O, /obj/overmap/entity/visitable/ship))
		GLOB.overmap_event_handler.on_turf_exited(src, O, newloc)

//! END
