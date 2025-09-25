//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/mortar_flight
	var/obj/item/ammo_casing/mortar/shell

	// TODO: use sector backend when it's done, for now we target single levels
	//       and cannot go across structs
	var/datum/map_level/flight_level
	var/flight_x
	var/flight_y
	var/flight_duration

	var/arrive_time

/datum/mortar_flight/New(obj/item/ammo_casing/mortar/shell)
	shell.moveToNullspace()

	src.shell = shell

/datum/mortar_flight/Destroy()
	QDEL_NULL(shell)
	flight_level = null
	return ..()

/datum/mortar_flight/proc/set_target(datum/map_level/level, virtual_x, virtual_y)
	src.flight_level = level
	src.flight_x = virtual_x
	src.flight_y = virtual_y

/datum/mortar_flight/proc/set_duration(time)
	src.flight_duration = time

/datum/mortar_flight/proc/set_log_data(datum/event_args/actor/firer)
	#warn impl / hook

/datum/mortar_flight/proc/run()
	src.arrive_time = world.time + flight_duration

/datum/mortar_flight/proc/get_mobs_in_radius_of_target(radius) as /list

/datum/mortar_flight/proc/get_target_turf() as /turf
	return locate(flight_x, flight_y, flight_level.z_index)

/datum/mortar_flight/proc/impact_warning()
	var/list/mob/send_to = get_mobs_in_radius_of_target(15)


/datum/mortar_flight/proc/impact()
	var/turf/maybe_target_turf = get_target_turf()

	#warn impl + log
	shell.on_detonate()

#warn impl
