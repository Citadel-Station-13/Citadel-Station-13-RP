//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/item/airlock_component/handler
	name = /obj/machinery/airlock_component/handler::name + " (detached)"
	desc = /obj/machinery/airlock_component/handler::desc
	machine_type = /obj/machinery/airlock_component/handler
	icon = /obj/machinery/airlock_component/handler::icon
	icon_state = /obj/machinery/airlock_component/handler::icon_state
	base_icon_state = /obj/machinery/airlock_component/handler::base_icon_state

/**
 * interface nodes of airlock networks
 * they handle the buffering of gas and power.
 */
/obj/machinery/airlock_component/handler
	name = "airlock handler"
	desc = "A set of underfloor machinery used to interface with an atmospherics and power network."
	icon = 'icons/machinery/airlocks/airlock_handler.dmi'
	icon_state = "handler"
	base_icon_state = "handler"

	detached_item_type = /obj/item/airlock_component/handler

	/// pipenet connectors
	var/list/obj/machinery/atmospherics/component/unary/airlock_connector/connectors
	/// layer used for ejection
	//  todo: vv hooks
	var/layer_eject = PIPING_LAYER_SCRUBBER
	/// layer used for intake
	//  todo: vv hooks
	var/layer_intake = PIPING_LAYER_SUPPLY

	/// power storage in kilojoules
	var/power_capacity = STATIC_CELL_UNITS_TO_KJ(POWER_CELL_CAPACITY_LARGE)
	/// power stored in kilojoules
	var/power_stored = STATIC_CELL_UNITS_TO_KJ(POWER_CELL_CAPACITY_LARGE)
	/// max power draw in kilowatts
	var/power_io = 75
	/// pumping power in kilowatts
	var/power_rating = 150

	var/obj/machinery/atmospherics/component/unary/airlock_connector/conn_eject
	var/obj/machinery/atmospherics/component/unary/airlock_connector/conn_intake

/obj/machinery/airlock_component/handler/Initialize(mapload)
	. = ..()
	create_or_update_conn_eject()
	create_or_update_conn_intake()

/obj/machinery/airlock_component/handler/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("This handler will connect to layers [piping_layer_to_numbered_name(layer_intake)] for intake and [piping_layer_to_numbered_name(layer_eject)] for ejection.")

/obj/machinery/airlock_component/handler/Destroy()
	QDEL_NULL(conn_eject)
	QDEL_NULL(conn_intake)
	return ..()

/obj/machinery/airlock_component/handler/Moved(atom/old_loc, direction, forced, list/old_locs, momentum_change)
	..()
	if(old_loc == loc)
		return
	create_or_update_conn_eject()
	create_or_update_conn_intake()

/obj/machinery/airlock_component/handler/on_connect(datum/airlock_gasnet/network)
	..()
	if(network.handler)
		// screaming time!
		network.queue_recheck()
	else
		// don't need to recheck at all unless we make things event driven later
		network.handler = src

/obj/machinery/airlock_component/handler/on_disconnect(datum/airlock_gasnet/network)
	..()
	if(network.handler == src)
		network.handler = null
		network.queue_recheck()

/obj/machinery/airlock_component/handler/process(delta_time)
	. = ..()
	#warn impl - power, atmos

/obj/machinery/airlock_component/handler/proc/get_clean_gas_mixture_ref() as /datum/gas_mixture
	return conn_intake?.air_contents

/obj/machinery/airlock_component/handler/proc/get_waste_gas_mixture_ref() as /datum/gas_mixture
	return conn_eject?.air_contents

/obj/machinery/airlock_component/handler/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE

/obj/machinery/atmospherics/component/unary/airlock_connector
	volume = 2000
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	atom_flags = ATOM_ABSTRACT | ATOM_NONWORLD
