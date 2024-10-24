//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/machinery/airlock_peripheral/sensor
	name = "airlock sensor"
	desc = "A multi-purpose environment analyzer for an airlock. Doubles as a button for when you need to get in or out."

	#warn sprite

	controller_linking = TRUE

	#warn impl

	/// if set, autodetect airlocks will consider this to be the authoritative sensor for that side.
	/// only one active inside / outside sensor each are allowed.
	/// button-only sensors are allowed in unlimited amounts.
	var/sidedness = null
	/// functions as a button. this is disabled during security lockdown.
	var/is_button = FALSE
	/// functions as a sensor. if this is off, the airlock won't use us as the sensor.
	var/is_sensor = FALSE

/obj/machinery/airlock_peripheral/sensor/vv_edit_var(var_name, new_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, sidedness))
			return FALSE
		if(NAMEOF(src, is_button))
			return FALSE
	return ..()

#warn impl

/**
 * Returned air must **never** be edited!
 */
/obj/machinery/airlock_peripheral/sensor/proc/probe_gas()
	return return_air_immutable()

/obj/machinery/airlock_peripheral/sensor/attack_ai(mob/user)
	. = ..()

/obj/machinery/airlock_peripheral/sensor/on_attack_hand(datum/event_args/actor/clickchain/e_args)
	. = ..()

/obj/machinery/airlock_peripheral/sensor/sensor_only
	name = "airlock sensor"
	desc = "An environment analyzer for an airlock. Don't block the front!"
	is_button = FALSE
	is_sensor = TRUE

/obj/machinery/airlock_peripheral/sensor/button_only
	name = "airlock button"
	desc = "A cycle button for an airlock."
	is_sensor = FALSE
	is_button = TRUE

/obj/machinery/airlock_peripheral/sensor/sensor_only/exterior
	sidedness = AIRLOCK_SIDE_EXTERIOR

/obj/machinery/airlock_peripheral/sensor/sensor_only/interior
	sidedness = AIRLOCK_SIDE_INTERIOR

/obj/machinery/airlock_peripheral/sensor/button_only/exterior
	sidedness = AIRLOCK_SIDE_EXTERIOR

/obj/machinery/airlock_peripheral/sensor/button_only/interior
	sidedness = AIRLOCK_SIDE_INTERIOR

/obj/machinery/airlock_peripheral/sensor/exterior
	sidedness = AIRLOCK_SIDE_EXTERIOR
	is_button = TRUE
	is_sensor = TRUE

/obj/machinery/airlock_peripheral/sensor/interior
	sidedness = AIRLOCK_SIDE_INTERIOR
	is_button = TRUE
	is_sensor = TRUE
