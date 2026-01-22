//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/**
 * External vent for an airlock.
 * * Optional, unlike controller and arguably cycler/links.
 * * Little more than a gas-ref provider.
 */
/obj/machinery/airlock_component/vent
	name = "airlock vent"
	desc = "A large vent used in an airlock to dispel unwanted waste gases and use as a heat source/sink."

	#warn sprite

	#warn impl this for icon update
	var/last_pump_time
	var/last_pump_was_out
	var/last_pump_icon_update_time

/obj/machinery/airlock_component/vent/on_connect(datum/airlock_gasnet/network)
	..()
	if(network.vent)
		// screaming time!
		network.queue_recheck()
	else
		// don't need to recheck at all unless we make things event driven later
		network.vent = src

/obj/machinery/airlock_component/vent/on_disconnect(datum/airlock_gasnet/network)
	..()
	if(network.vent == src)
		network.vent = null
		network.queue_recheck()

/obj/machinery/airlock_component/vent/process(delta_time)
	if(last_pump_time != last_pump_icon_update_time)
		update_icon()
		last_pump_time = world.time

/obj/machinery/airlock_component/vent/update_icon(updates)
	. = ..()
	#warn impl

/**
 * Gets gas mixture to use for handler / cycler procs.
 * * This should wake the zone as needed, because the mixture will probably be modified.
 */
/obj/machinery/airlock_component/vent/proc/get_mutable_gas_mixture_ref() as /datum/gas_mixture
	return loc.return_air_mutable()

/obj/machinery/airlock_component/vent/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
