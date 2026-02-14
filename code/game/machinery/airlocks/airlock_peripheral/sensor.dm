//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

// todo: buildable

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor, 22)
/obj/machinery/airlock_peripheral/sensor
	name = "airlock sensor"
	desc = "A multi-purpose environment analyzer for an airlock. Doubles as a button for when you need to get in or out."
	icon = 'icons/machinery/airlocks/airlock_sensor.dmi'
	icon_state = "sensor"
	base_icon_state = "sensor"

	/// if set, autodetect airlocks will consider this to be the authoritative sensor for that side.
	/// only one active inside / outside sensor each are allowed.
	/// button-only sensors are allowed in unlimited amounts.
	var/sidedness = null
	/// functions as a button. this is disabled during security lockdown.
	var/is_button = FALSE
	/// functions as a sensor. if this is off, the airlock won't use us as the sensor.
	var/is_sensor = FALSE

// TODO: on_power_change
/obj/machinery/airlock_peripheral/sensor/power_change()
	. = ..()
	if(!.)
		return
	update_icon()

/obj/machinery/airlock_peripheral/sensor/update_icon(updates)
	. = ..()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]-off"
	else
		icon_state = "[base_icon_state]"
	// todo: handle 'operating' as "[base_icon_state]-active"
	// todo: handle 'alert' if 'is_sensor' as "[base_icon_state]-alert"

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

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/hardmapped, 22)
/obj/machinery/airlock_peripheral/sensor/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/button, 22)
/obj/machinery/airlock_peripheral/sensor/button
	name = "airlock button"
	desc = "A cycle button for an airlock."
	is_sensor = FALSE
	is_button = TRUE
	icon_state = "button"
	base_icon_state = "button"

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/button/hardmapped, 22)
/obj/machinery/airlock_peripheral/sensor/button/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/button/exterior, 22)
/obj/machinery/airlock_peripheral/sensor/button/exterior
	sidedness = AIRLOCK_SIDE_EXTERIOR

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/button/exterior/hardmapped, 22)
/obj/machinery/airlock_peripheral/sensor/button/exterior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/button/interior, 22)
/obj/machinery/airlock_peripheral/sensor/button/interior
	sidedness = AIRLOCK_SIDE_INTERIOR

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/button/interior/hardmapped, 22)
/obj/machinery/airlock_peripheral/sensor/button/interior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/exterior, 22)
/obj/machinery/airlock_peripheral/sensor/exterior
	sidedness = AIRLOCK_SIDE_EXTERIOR
	is_button = TRUE
	is_sensor = TRUE

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/exterior/hardmapped, 22)
/obj/machinery/airlock_peripheral/sensor/exterior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/interior, 22)
/obj/machinery/airlock_peripheral/sensor/interior
	sidedness = AIRLOCK_SIDE_INTERIOR
	is_button = TRUE
	is_sensor = TRUE

CREATE_WALL_MOUNTING_TYPES_SHIFTED(/obj/machinery/airlock_peripheral/sensor/interior/hardmapped, 22)
/obj/machinery/airlock_peripheral/sensor/interior/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
