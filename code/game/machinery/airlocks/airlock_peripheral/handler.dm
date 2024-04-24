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
	/// power draw in kilowatts
	var/power_draw = 75

#warn impl

/**
 * todo: refactor on atmospherics machinery update
 */
/obj/machinery/atmospherics/component/unary/airlock_connector

