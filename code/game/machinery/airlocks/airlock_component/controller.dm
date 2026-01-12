//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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

	//* Access *//
	/// we can access the airlock from the controller
	var/control_panel = TRUE

	//* Composition *//
	/// Our airlock system
	var/datum/airlock_system/system
	/// Starting program typepath
	var/program_path = /datum/airlock_program/vacuum_cycle

	//* Network *//
	/// our connected gasnet
	var/datum/airlock_gasnet/network

	//* Cycling - Op *//
	/// operation cycle; airlock cycling is async, operation cycles allow us to ensure
	/// that an operation is still the same operation something started.
	var/op_cycle
	/// next operation cycle
	var/static/op_cycle_next = 0
	/// what to call on finish with (status: AIRLOCK_OP_STATUS_* define, why: short string reason or null)
	var/datum/callback/op_on_finish

/obj/machinery/airlock_component/controller/Initialize(mapload)
	..()
	// todo: we need proper tick bracket machine support & fastmos
	STOP_MACHINE_PROCESSING(src)
	system = new(src, new program_path)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/airlock_component/controller/Destroy()
	STOP_MACHINE_PROCESSING(src)
	STOP_PROCESSING(SSprocess_5fps, src)
	QDEL_NULL(system)
	return ..()

/obj/machinery/airlock_component/controller/LateInitialize()
	. = ..()

/obj/machinery/airlock_component/controller/preloading_instance(with_id)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, with_id)

#warn impl all
