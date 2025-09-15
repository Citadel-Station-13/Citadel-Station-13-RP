//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/**
 * interface nodes of airlock networks
 * they handle the buffering of gas and power.
 */
/obj/machinery/airlock_component/handler
	name = "airlock handler"
	desc = "A set of underfloor machinery used to interface with an atmospherics and power network."
	#warn sprite

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

	/// power storage in joules
	var/power_capacity = 1000000
	/// max power draw in kilowatts
	var/power_io = 75
	/// power stored in joules
	var/power_stored = 1000000

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

#warn requires panel open

/**
 * todo: refactor on atmospherics machinery update
 */
/obj/machinery/atmospherics/component/unary/airlock_connector
	// volume = 2000
