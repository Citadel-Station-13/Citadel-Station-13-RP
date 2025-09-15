//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base peripheral system for things that connect to controllers
 */
/obj/machinery/airlock_peripheral
	/// connected controller
	var/obj/machinery/airlock_component/controller/controller
	/// airlock ID to link to; will be automatically mangled
	var/controller_link_id

/obj/machinery/airlock_peripheral/preloading_instance(datum/dmm_context/context)
	. = ..()
	if(controller_link_id)
		controller_link_id = SSmapping.mangled_round_local_id(controller_link_id, context.mangling_id)

/obj/machinery/airlock_peripheral/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/airlock_peripheral/LateInitialize()
	. = ..()
	#warn link to controller

#warn impl



