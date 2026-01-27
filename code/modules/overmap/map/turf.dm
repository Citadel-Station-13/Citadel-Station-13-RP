
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

	/// used for collisions
	var/wrap_sign_x
	/// used for collisions
	var/wrap_sign_y

/turf/overmap/edge/initialize_overmap(datum/overmap/map)
	name = "border"
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

/turf/overmap/edge/Enter(atom/movable/mover, atom/oldloc)
	if(istype(mover, /obj/overmap))
		return FALSE
	return ..()

/turf/overmap/edge/Bumped(atom/movable/bumped_atom)
	. = ..()
	if(istype(bumped_atom, /obj/overmap/entity))
		var/obj/overmap/entity/entity = bumped_atom
		// bounce them off
		elastic_collision(entity)

/turf/overmap/edge/proc/elastic_collision(obj/overmap/entity/entity)
	if(wrap_sign_x != 0 && (wrap_sign_x > 0 != entity.vel_x > 0))
		if(wrap_sign_y != 0 && (wrap_sign_y > 0 != entity.vel_y > 0))
			entity.set_velocity(-entity.vel_x, -entity.vel_y)
			entity.bump_handled = TRUE
		else
			entity.set_velocity(-entity.vel_x, null)
			entity.bump_handled = TRUE
	else if(wrap_sign_y != 0 && (wrap_sign_y > 0 != entity.vel_y > 0))
		entity.set_velocity(null, -entity.vel_y)
		entity.bump_handled = TRUE

//! LEGACY BELOW

/turf/overmap/Destroy()
	for(var/obj/overmap/entity/visitable/ship/entity in src)
		Exited(entity)
	return ..()

/turf/overmap/Entered(var/atom/movable/O, var/atom/oldloc)
	..()
	if(istype(O, /obj/overmap/entity/visitable/ship))
		GLOB.overmap_event_handler.on_turf_entered(src, O, oldloc)

/turf/overmap/Exited(var/atom/movable/O, var/atom/newloc)
	..()
	if(istype(O, /obj/overmap/entity/visitable/ship))
		GLOB.overmap_event_handler.on_turf_exited(src, O, newloc)

//! END
