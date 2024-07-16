
/area/overmap
	name = "System Map"
	icon_state = "start"
	area_power_override = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED

/turf/overmap
	name = "--init--"
	desc = "If you see this, it means coders didn't update the description but did allow perspective-relayed examine. Yell at them."
	icon = 'icons/modules/overmap/turf.dmi'
	icon_state = "map"
	permit_ao = FALSE

	maptext_height = 32
	maptext_width = 32
	maptext_x = 0
	maptext_y = 12

/turf/overmap/proc/initialize_overmap(datum/overmap/map)
	return TRUE

/turf/overmap/map
	opacity = FALSE
	density = FALSE

/turf/overmap/map/initialize_overmap(datum/overmap/map)
	var/calculated_x = x - map.lower_left_x
	var/calculated_y = y - map.lower_left_y
	name = "[calculated_x]-[calculated_y]"
	return ..()

/turf/overmap/edge
	opacity = TRUE
	density = TRUE

	/// stores a reference to our overmap for wrap purposes
	///
	/// todo: is this a good method? it works for now but i hate storing turf vars...
	var/datum/overmap/overmap
	/// sign of wrap, x
	var/wrap_sign_x
	/// sign of wrap, y
	var/wrap_sign_y

/turf/overmap/edge/initialize_overmap(datum/overmap/map)
	name = "border (warp-enabled)"
	overmap = map
	return ..()

/**
 * initializes our locality
 *
 * remember: at this point, overmap hasn't been set, because we're currently being called from a /datum/turf_reservation!
 */
/turf/overmap/edge/proc/initialize_border(datum/overmap/map, datum/turf_reservation/reservation)
	var/lower_left_x = reservation.bottom_left_coords[1]
	var/lower_left_y = reservation.bottom_left_coords[2]
	var/upper_right_x = reservation.top_right_coords[1]
	var/upper_right_y = reservation.top_right_coords[2]

	var/number
	if((x == lower_left_x - 1) || (x == upper_right_x + 1))
		// left or right borders
		if((y == lower_left_y - 1) || (y == upper_right_y + 1))
		else
			number = y - lower_left_y + 1
	else if((y == lower_left_y - 1) || (y == upper_right_y + 1))
		// top or bottom borders
		if((x == lower_left_x - 1) || (x == upper_right_x + 1))
		else
			number = x - lower_left_x + 1

	wrap_sign_x = 0
	wrap_sign_y = 0

	if(x == lower_left_x - 1)
		if(y == lower_left_y - 1)
			wrap_sign_y = 1
		wrap_sign_x = 1
	else if(x == upper_right_x + 1)
		if(y == upper_right_y + 1)
			wrap_sign_y = -1
		wrap_sign_x = -1
	if(y == lower_left_y - 1)
		if(x == upper_right_x + 1)
			wrap_sign_x = -1
		wrap_sign_y = 1
	else if(y == upper_right_y + 1)
		if(x == lower_left_x - 1)
			wrap_sign_x = 1
		wrap_sign_y = -1

	if(number)
		maptext = MAPTEXT_CENTER("[number]")

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
