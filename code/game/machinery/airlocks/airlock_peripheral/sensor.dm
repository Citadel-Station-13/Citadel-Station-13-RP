//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/machinery/airlock_peripheral/sensor
	name = "airlock sensor"
	desc = "A multi-purpose environment analyzer for an airlock. Doubles as a button for when you need to get in or out."

	#warn sprite
	#warn impl

	/// if set, autodetect airlocks will consider this to be the authoritative sensor for that side.
	/// only one active inside / outside sensor each are allowed.
	/// button-only sensors are allowed in unlimited amounts.
	var/sidedness = null
	/// functions as a button. this is disabled during security lockdown.
	var/is_button = FALSE
	/// functions as a sensor. if this is off, the airlock won't use us as the sensor.
	var/is_sensor = FALSE

/**
 * Returned air must **never** be edited!
 */
/obj/machinery/airlock_peripheral/sensor/proc/probe_gas_immutable()
	return return_air_immutable()

/obj/machinery/airlock_peripheral/sensor/attack_ai(mob/user)
	. = ..()
	if(.)
		return
	// TODO: refactor attack_ai we need a way to abort; clickchain flags?
	on_cycle_request(new /datum/event_args/actor(user))
	return TRUE

/obj/machinery/airlock_peripheral/sensor/on_attack_hand(datum/event_args/actor/clickchain/e_args)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(is_button)
		on_cycle_request(e_args)
		return CLICKCHAIN_DID_SOMETHING

/obj/machinery/airlock_peripheral/sensor/proc/on_cycle_request(datum/event_args/actor/actor)
	controller?.on_sensor_cycle_request(src, actor)

/obj/machinery/airlock_peripheral/sensor/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_peripheral/sensor/sensor_only
	name = "airlock reader"
	desc = "An environment analyzer for an airlock. Don't block the front!"
	is_button = FALSE
	is_sensor = TRUE

/obj/machinery/airlock_peripheral/sensor/sensor_only/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_peripheral/sensor/button_only
	name = "airlock button"
	desc = "A cycle button for an airlock."
	is_sensor = FALSE
	is_button = TRUE

/obj/machinery/airlock_peripheral/sensor/button_only/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_peripheral/sensor/sensor_only/exterior
	sidedness = AIRLOCK_SIDE_EXTERIOR

/obj/machinery/airlock_peripheral/sensor/sensor_only/exterior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_peripheral/sensor/sensor_only/interior
	sidedness = AIRLOCK_SIDE_INTERIOR

/obj/machinery/airlock_peripheral/sensor/sensor_only/interior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_peripheral/sensor/button_only/exterior
	sidedness = AIRLOCK_SIDE_EXTERIOR

/obj/machinery/airlock_peripheral/sensor/button_only/exterior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_peripheral/sensor/button_only/interior
	sidedness = AIRLOCK_SIDE_INTERIOR

/obj/machinery/airlock_peripheral/sensor/button_only/interior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_peripheral/sensor/exterior
	sidedness = AIRLOCK_SIDE_EXTERIOR
	is_button = TRUE
	is_sensor = TRUE

/obj/machinery/airlock_peripheral/sensor/exterior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_peripheral/sensor/interior
	sidedness = AIRLOCK_SIDE_INTERIOR
	is_button = TRUE
	is_sensor = TRUE

/obj/machinery/airlock_peripheral/sensor/interior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
