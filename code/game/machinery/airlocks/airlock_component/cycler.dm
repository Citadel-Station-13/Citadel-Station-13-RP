//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/airlock_component/cycler
	name = /obj/machinery/airlock_component/cycler::name + " (detached)"
	desc = /obj/machinery/airlock_component/cycler::desc
	machine_type = /obj/machinery/airlock_component/cycler
	icon = /obj/machinery/airlock_component/cycler::icon
	icon_state = /obj/machinery/airlock_component/cycler::icon_state
	base_icon_state = /obj/machinery/airlock_component/cycler::base_icon_state

	// TODO: pumping power carry-over maybe?

/**
 * Internal cycling vent/scrubber for an airlock.
 * * Little more than a gas-ref provider, for now
 */
/obj/machinery/airlock_component/cycler
	name = "airlock cycler"
	desc = "A set of machinery used for manipulating the atmosphere inside of an airlock. Doubles as a gas sensor."
	icon = 'icons/machinery/airlocks/airlock_cycler.dmi'
	icon_state = "cycler"
	base_icon_state = "cycler"

	detached_item_type = /obj/item/airlock_component/cycler

	/// max pumping power in kw
	var/pumping_power = 50

	/// TRUE for out, FALSE for in, null for neither
	var/last_pump_was_out
	var/last_pump_applied_state

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
	last_pump_was_out = null

/obj/machinery/airlock_component/cycler/process(delta_time)
	if(last_pump_was_out != last_pump_applied_state)
		update_icon()

/obj/machinery/airlock_component/cycler/update_icon(updates)
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
/obj/machinery/airlock_component/cycler/proc/get_mutable_gas_mixture_ref() as /datum/gas_mixture
	return loc.return_air_mutable()

/obj/machinery/airlock_component/cycler/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
