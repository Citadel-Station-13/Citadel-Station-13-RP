//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
	/// layer used for heat exchange
	//  todo: vv hooks
	var/layer_heat = PIPING_LAYER_AUX

	/// power storage in kilojoules
	var/power_capacity = 3000
	/// power stored in kilojoules
	var/power_stored = 3000
	/// max power draw in kilowatts
	var/power_io = 75

	//  todo: vv hooks
	var/air_buffer_volume_clean = CELL_VOLUME * 4
	//  todo: vv hooks
	var/air_buffer_volume_dirty = CELL_VOLUME * 4

	/// pumping power in kilowatts
	var/pumping_power = 30000

	/// our clean gas mixture
	var/datum/gas_mixture/air_buffer_clean
	/// our dirty gas mixture
	var/datum/gas_mixture/air_buffer_dirty

/obj/machinery/airlock_component/handler/Initialize(mapload)
	. = ..()
	air_buffer_clean = new(air_buffer_volume_clean)
	air_buffer_dirty = new(air_buffer_volume_dirty)

#warn impl

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

/obj/machinery/airlock_component/handler/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	#warn impl

/obj/machinery/airlock_component/handler/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/airlock_component/handler/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/airlock_component/handler/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockHandler")
		ui.open()

/obj/machinery/airlock_component/handler/proc/get_clean_gas_mixture_ref() as /datum/gas_mixture

/obj/machinery/airlock_component/handler/proc/get_waste_gas_mixture_ref() as /datum/gas_mixture

#warn requires panel open

/obj/machinery/airlock_component/handler/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/**
 * todo: refactor on atmospherics machinery update
 */
/obj/machinery/atmospherics/component/unary/airlock_connector
	// volume = 2000
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
