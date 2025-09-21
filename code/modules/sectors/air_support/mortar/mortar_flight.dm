//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/mortar_flight
	var/obj/item/ammo_casing/mortar/shell

	// TODO: use sector backend when it's done, for now we target single levels
	//       and cannot go across structs
	var/datum/map_level/flight_level
	var/arrive_time

/datum/mortar_flight/New(obj/item/ammo_casing/mortar/shell, datum/map_level/flight_level, flight_time)
	shell.moveToNullspace()

	src.shell = shell
	src.flight_level = flight_level
	src.arrive_time = world.time + flight_time

	if(!src.shell || !src.flight_level || !src.arrive_time)
		qdel(src)
		CRASH("mortar flight missing params")
		return

	run()

/datum/mortar_flight/Destroy()
	QDEL_NULL(shell)
	flight_level = null
	return ..()

/datum/mortar_flight/proc/run()

#warn impl
