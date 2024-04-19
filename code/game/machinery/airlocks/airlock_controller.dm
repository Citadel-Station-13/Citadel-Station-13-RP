//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Airlock controllers
 *
 * * Uses a state-reconcile pattern where we attempt to change the chamber to match the wanted state.
 */
/obj/machinery/airlock_controller
	name = "airlock controller"
	desc = "A self-contained controller for an airlock."
	#warn sprite

	//* Access
	/// we can access the airlock from the controller
	var/control_panel = TRUE

	//* Peripherals
	/// panels
	var/list/obj/machinery/airlock_peripheral/panel/panels
	/// handlers
	var/list/obj/machinery/airlock_peripheral/handler/handlers
	/// cyclers
	var/list/obj/machinery/airlock_peripheral/cycler/cyclers
	/// sensors
	var/list/obj/machinery/airlock_peripheral/sensor/sensors

	//* Doors
	/// interior doors
	var/list/obj/machinery/door/interior
	/// exterior doors
	var/list/obj/machinery/door/exterior

	//* Shuttles
	/// linked dock, if any
	var/obj/shuttle_dock/dock

	//* State
	/// door state
	var/door_state = AIRLOCK_DOORS_UNLOCAIRLOCK_DOCK_NONEKED
	/// dock state
	var/dock_state = AIRLOCK_DOCK_NONE
	/// mode state
	var/mode_state
	/// operation state
	var/op_state
	/// operation cycle; used for things like asyncs to be able to verify behavior.
	var/op_cycle
	/// next operation cycle
	var/static/op_cycle_next = 0


#warn impl

/**
 * Automatically builds its airlock by calculating the necessary geometry.
 * * Only works with relatively plain, rectangular airlocks.
 * * An /obj/map_helper/airlock_interior must be placed on the interior airlock set.
 */
/obj/machinery/airlock_controller/autodetect

#warn impl

/**
 * Automatically builds its airlock by calculating the necessary geometry.
 * * Only works with relatively plain, rectangular airlocks.
 * * An /obj/map_helper/airlock_interior must be placed on the interior airlock set.
 * * Links to an /obj/shuttle_dock if one is detected.
 * * Defaults to being indestructible, as there's no in-game way to interact with a dock right now.
 */
/obj/machinery/airlock_controller/autodetect/docking
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

#warn impl
