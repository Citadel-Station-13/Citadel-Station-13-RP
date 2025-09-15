//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base peripheral system for things that connect to controllers
 */
/obj/machinery/airlock_peripheral
	/// connected controller
	var/obj/machinery/airlock_component/controller/controller
	/// airlock ID to link to; will be automatically mangled
	var/airlock_id

/obj/machinery/airlock_peripheral/vv_edit_var(var_name, new_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, controller_linking))
			return FALSE
	return ..()

/obj/machinery/airlock_peripheral/preloading_instance(datum/dmm_context/context)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, context.mangling_id)

/obj/machinery/airlock_peripheral/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/airlock_peripheral/LateInitialize()
	. = ..()
	#warn link to controller

#warn impl



