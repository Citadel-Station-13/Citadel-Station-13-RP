//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

// TODO: buildable; may require new frame system as some of these are sided / wall-mounted

/**
 * Base peripheral system for things that connect to controllers
 */
/obj/machinery/airlock_peripheral
	/// connected controller
	var/obj/machinery/airlock_component/controller/controller
	/// airlock ID to link to; will be automatically mangled
	var/controller_autolink_id
	/// hardmapped?
	var/hardmapped = FALSE

/obj/machinery/airlock_peripheral/preloading_from_mapload(datum/dmm_context/context)
	. = ..()
	if(controller_autolink_id)
		controller_autolink_id = SSmapping.mangled_round_local_id(controller_autolink_id, context.mangling_id)

/obj/machinery/airlock_peripheral/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/airlock_peripheral/LateInitialize()
	if(!controller_autolink_id)
		return
	var/obj/machinery/airlock_component/controller/maybe_controller = GLOB.airlock_controller_lookup[controller_autolink_id]
	if(!maybe_controller)
		// this is an error because autolink id is only set by mappers,
		// so if it doesn't link a mapper fucked up
		CRASH("couldn't find a controller for [controller_autolink_id]")
	connect_to_controller(maybe_controller)

/obj/machinery/airlock_peripheral/Destroy()
	disconnect_from_controller()
	return ..()

/obj/machinery/airlock_peripheral/proc/on_controller_join(obj/machinery/airlock_component/controller/controller)
	return

/obj/machinery/airlock_peripheral/proc/on_controller_leave(obj/machinery/airlock_component/controller/controller)
	return

/obj/machinery/airlock_peripheral/proc/connect_to_controller(obj/machinery/airlock_component/controller/controller)
	return controller.add_peripheral(src)

/obj/machinery/airlock_peripheral/proc/disconnect_from_controller()
	return controller.remove_peripheral(src)
