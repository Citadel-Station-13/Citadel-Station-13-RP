//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * interface nodes of airlock networks
 * they handle the buffering of gas and power.
 */
/obj/machinery/airlock_peripheral/handler
	name = "airlock handler"
	desc = "A set of underfloor machinery used to interface with an atmospherics and power network."
	#warn sprite

	/// conencted pipenet
	var/datum/airlock_pipenet/network

	/// pipenet connectors
	var/list/obj/machinery/atmospherics/component/unary/airlock_connector/connectors
	/// layer used for ejection
	var/layer_eject = PIPING_LAYER_SCRUBBER
	/// layer used for intake
	var/layer_intake = PIPING_LAYER_SUPPLY
	/// layer used for heat exchange
	var/layer_heat = PIPING_LAYER_AUX

	/// power storage in kilojoules
	var/power_storage = 1000
	/// power draw in kilowatts; used for charging.
	var/power_draw = 75

	/// liters of gas this can store per gas type
	var/air_storage = CELL_VOLUME

	/// pumping power in kilowatts
	var/pumping_power = 30

#warn impl

/obj/machinery/airlock_peripheral/handler/process(delta_time)
	. = ..()
	#warn impl - power, atmos

/obj/machinery/airlock_peripheral/handler/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	#warn impl

/obj/machinery/airlock_peripheral/handler/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/airlock_peripheral/handler/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/airlock_peripheral/handler/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AirlockHandler")
		ui.open()

#warn requires panel open

/**
 * todo: refactor on atmospherics machinery update
 */
/obj/machinery/atmospherics/component/unary/airlock_connector
	volume = 2000
