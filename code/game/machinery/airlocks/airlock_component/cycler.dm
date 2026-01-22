//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/**
 * Internal cycling vent/scrubber for an airlock.
 * * Little more than a gas-ref provider, for now
 */
/obj/machinery/airlock_component/cycler
	name = "airlock cycler"
	desc = "A set of machinery used for manipulating the atmosphere inside of an airlock. Doubles as a gas sensor."
	#warn sprite

	/// max pumping power in kw
	var/pumping_power = 50

	#warn impl this for icon update
	var/last_pump_time
	var/last_pump_was_out
	var/last_pump_icon_update_time

/obj/machinery/airlock_component/cycler/on_connect(datum/airlock_gasnet/network)
	..()
	if(network.cycler)
		// screaming time!
		network.queue_recheck()
	else
		// don't need to recheck at all unless we make things event driven later
		network.cycler = src

/obj/machinery/airlock_component/cycler/on_disconnect(datum/airlock_gasnet/network)
	..()
	if(network.cycler == src)
		network.cycler = null
		network.queue_recheck()

/obj/machinery/airlock_component/cycler/process(delta_time)
	if(last_pump_time != last_pump_icon_update_time)
		update_icon()
		last_pump_time = world.time

/obj/machinery/airlock_component/cycler/update_icon(updates)
	. = ..()
	#warn impl

/**
 * Gets gas mixture to use for handler / cycler procs.
 * * This should wake the zone as needed, because the mixture will probably be modified.
 */
/obj/machinery/airlock_component/cycler/proc/get_mutable_gas_mixture_ref() as /datum/gas_mixture
	return loc.return_air_mutable()

/obj/machinery/airlock_component/cycler/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
