//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY(airlock_controller_lookup)

// todo: buildable

/**
 * Airlock controllers
 *
 * * Uses a state-reconcile pattern where we attempt to change the chamber to match the wanted state.
 */
/obj/machinery/airlock_component/controller
	name = "airlock controller"
	desc = "A self-contained controller for an airlock."
	#warn sprite

	/// Airlock ID
	/// * Controller is the wireless AP, effectively, so only controller has an ID;
	///   the rest of the gasnet doesn't.
	var/airlock_id

	//* Access *//
	/// we can access the airlock from the controller
	var/control_panel = TRUE

	//* Airlock *//

	/// Our airlock system
	var/datum/airlock_system/system
	/// Starting program typepath
	var/program_path = /datum/airlock_program/vacuum_cycle
	/// connected peripherals
	var/list/obj/machinery/airlock_peripheral/peripherals

/obj/machinery/airlock_component/controller/Initialize(mapload)
	..()
	// todo: we need proper tick bracket machine support & fastmos
	STOP_MACHINE_PROCESSING(src)
	system = new(src, new program_path)
	set_controller_id(src.airlock_id)

/obj/machinery/airlock_component/controller/preloading_from_mapload(datum/dmm_context/context)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, context.mangling_id)

/obj/machinery/airlock_component/controller/Destroy()
	STOP_MACHINE_PROCESSING(src)
	STOP_PROCESSING(SSprocess_5fps, src)
	set_controller_id(null)
	QDEL_NULL(system)
	return ..()

/obj/machinery/airlock_component/controller/on_connect(datum/airlock_gasnet/network)
	..()
	if(network.controller)
		// screaming time!
		network.queue_recheck()
	else
		// don't need to recheck at all unless we make things event driven later
		network.controller = src

/obj/machinery/airlock_component/controller/on_disconnect(datum/airlock_gasnet/network)
	..()
	if(network.controller == src)
		network.controller = null
		network.queue_recheck()

/**
 * @return TRUE success, FALSE failure
 */
/obj/machinery/airlock_component/controller/proc/set_controller_id(to_id)
	if(GLOB.airlock_controller_lookup[to_id])
		return FALSE
	if(!isnull(src.airlock_id))
		GLOB.airlock_controller_lookup -= src.airlock_id
	src.airlock_id = to_id
	#warn unlink peripherals if they're on our ID
	if(!isnull(src.airlock_id))
		GLOB.airlock_controller_lookup[src.airlock_id] = src

#warn impl all

/obj/machinery/airlock_component/controller/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
