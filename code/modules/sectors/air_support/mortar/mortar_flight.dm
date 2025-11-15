//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/mortar_flight
	var/obj/item/ammo_casing/mortar/shell
	/// target map struct
	var/datum/map/flight_map
	/// as virtual x
	var/flight_x
	/// as virtual y
	var/flight_y
	/// as struct z
	var/flight_z
	var/flight_duration

	var/arrive_time

/datum/mortar_flight/New(obj/item/ammo_casing/mortar/shell)
	shell.moveToNullspace()

	src.shell = shell

/datum/mortar_flight/Destroy()
	QDEL_NULL(shell)
	flight_map = null
	return ..()

/datum/mortar_flight/proc/set_target(datum/map/map, virtual_x, virtual_y, virtual_z)
	src.flight_map = map
	src.flight_x = virtual_x
	src.flight_y = virtual_y
	src.flight_z = virtual_z

/datum/mortar_flight/proc/set_duration(time)
	src.flight_duration = time

/datum/mortar_flight/proc/set_log_data(datum/event_args/actor/firer)
	#warn impl / hook

/datum/mortar_flight/proc/run()
	#warn impl?
	src.arrive_time = world.time + flight_duration

/datum/mortar_flight/proc/get_mobs_in_radius_of_target(radius) as /list

/datum/mortar_flight/proc/get_target_turf() as /turf
	return SSmapping.get_virtual_turf(flight_map, flight_x, flight_y, flight_z)

/datum/mortar_flight/proc/impact_warning()
	var/list/mob/send_to = get_mobs_in_radius_of_target(15)


/datum/mortar_flight/proc/impact()
	var/turf/maybe_target_turf = get_target_turf()

	#warn impl + log
	shell.on_detonate()

#warn impl
