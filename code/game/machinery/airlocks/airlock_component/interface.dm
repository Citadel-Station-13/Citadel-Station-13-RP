//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/item/airlock_component/interface
	name = /obj/machinery/airlock_component/interface::name + " (detached)"
	desc = /obj/machinery/airlock_component/interface::desc
	icon = /obj/machinery/airlock_component/interface::icon
	icon_state = /obj/machinery/airlock_component/interface::icon_state
	base_icon_state = /obj/machinery/airlock_component/interface::base_icon_state

	machine_type = /obj/machinery/airlock_component/interface

	// TODO: what needs to be carried over?

/**
 * Interface entity; allows airlocks to be controlled by external factors, like docking.
 */
/obj/machinery/airlock_component/interface
	name = "airlock interface"
	desc = "An adapter for an airlock that integrates it with an external source of control."
	icon = 'icons/machinery/airlocks/airlock_interface.dmi'
	icon_state = "interface"
	base_icon_state = "interface"

	detached_item_type = /obj/item/airlock_component/interface

/obj/machinery/airlock_component/interface/on_connect(datum/airlock_gasnet/network)
	..()
	if(network.interface)
		// screaming time!
		network.queue_recheck()
	else
		// don't need to recheck at all unless we make things event driven later
		network.interface = src

/obj/machinery/airlock_component/interface/on_disconnect(datum/airlock_gasnet/network)
	..()
	if(network.interface == src)
		network.interface = null
		network.queue_recheck()

/obj/machinery/airlock_component/interface/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
