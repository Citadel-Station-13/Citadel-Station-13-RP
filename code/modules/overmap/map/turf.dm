
/turf/overmap
	name = "--init--"
	desc = "If you see this, it means coders didn't update the description but did allow perspective-relayed examine. Yell at them."
	icon = 'icons/modules/overmap/turf.dmi'
	icon_state = "map"
	permit_ao = FALSE

	maptext_width = 32
	maptext_y = 12

/turf/overmap/proc/initialize_overmap(datum/overmap/map)
	return

/turf/overmap/map
	opacity = FALSE
	density = FALSE

/turf/overmap/map/initialize_overmap(datum/overmap/map)
	var/calculated_x = x - map.lower_left_x
	var/calculated_y = y - map.lower_left_y
	name = "[calculated_x]-[calculated_y]"

/turf/overmap/edge
	opacity = TRUE
	density = TRUE

	/// stores a reference to our overmap for wrap purposes
	///
	/// todo: is this a good method? it works for now but i hate storing turf vars...
	var/datum/overmap/overmap

/turf/overmap/edge/initialize_overmap(datum/overmap/map)
	name = "border (warp-enabled)"
	overmap = map

	var/number
	if(x == map.lower_left_x - 1 || x == map.upper_right_x + 1)
		// left or right borders
		number = y - map.lower_left_y
	else if(y == map.lower_left_y - 1 || y == map.upper_right_y + 1)
		// top or bottom borders
		number = x - map.lower_left_x

	maptext = MAPTEXT("[number]")

/**
 * get where a ship wraps to when it touches us
 *
 * supports diagonals.
 */
/turf/overmap/edge/proc/get_wrap_counterpart()
	if(x == overmap.lower_left_x - 1)
		if(y == overmap.lower_left_y - 1)
			return locate(overmap.upper_right_x, overmap.upper_right_y, z)
		return locate(overmap.upper_right_x, y, z)
	else if(x == overmap.upper_right_x + 1)
		if(y == overmap.upper_right_y + 1)
			return locate(overmap.lower_left_x, overmap.lower_left_y, z)
		return locate(overmap.lower_left_x, y, z)
	if(y == overmap.lower_left_y - 1)
		if(x == overmap.upper_right_x + 1)
			return locate(overmap.lower_left_x, overmap.upper_right_y, z)
		return locate(x, overmap.upper_right_y, z)
	else if(y == overmap.upper_right_y + 1)
		if(x == overmap.lower_left_x - 1)
			return locate(overmap.upper_right_x, overmap.lower_left_y, z)
		return locate(x, overmap.lower_left_y, z)

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
