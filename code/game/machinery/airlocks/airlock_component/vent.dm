//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/item/airlock_component/vent
	name = /obj/machinery/airlock_component/vent::name + " (detached)"
	desc = /obj/machinery/airlock_component/vent::desc
	machine_type = /obj/machinery/airlock_component/vent
	icon = /obj/machinery/airlock_component/vent::icon
	icon_state = /obj/machinery/airlock_component/vent::icon_state
	base_icon_state = /obj/machinery/airlock_component/vent::base_icon_state

/**
 * External vent for an airlock.
 * * Optional, unlike controller and arguably cycler/links.
 * * Little more than a gas-ref provider.
 */
/obj/machinery/airlock_component/vent
	name = "airlock vent"
	desc = "A large vent used in an airlock to dispel unwanted waste gases and use as a heat source/sink."
	icon = 'icons/machinery/airlocks/airlock_vent.dmi'
	icon_state = "vent"
	base_icon_state = "vent"

	detached_item_type = /obj/item/airlock_component/vent

	/// TRUE for out, FALSE for in, null for neither
	var/last_pump_was_out
	var/last_pump_applied_state

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
	last_pump_was_out = null

/obj/machinery/airlock_component/vent/process(delta_time)
	if(last_pump_was_out != last_pump_applied_state)
		update_icon()

/obj/machinery/airlock_component/vent/update_icon(updates)
	cut_overlays()
	. = ..()
	last_pump_applied_state = last_pump_was_out
	switch(last_pump_was_out)
		if(TRUE)
			add_overlay("[base_icon_state]-op-red")
		if(FALSE)
			add_overlay("[base_icon_state]-op-blue")

/**
 * Gets gas mixture to use for handler / cycler procs.
 * * This should wake the zone as needed, because the mixture will probably be modified.
 */
/obj/machinery/airlock_component/vent/proc/get_mutable_gas_mixture_ref() as /datum/gas_mixture
	return loc.return_air_mutable()

/obj/machinery/airlock_component/vent/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
