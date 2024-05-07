//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Base peripheral system for things that connect to controllers
 */
/obj/machinery/airlock_peripheral
	/// connected controller
	var/obj/machinery/airlock_controller/controller
	/// airlock ID to link to; will be automatically mangled
	var/airlock_id
	/// do we link to a controller?
	var/controller_linking = FALSE

/obj/machinery/airlock_peripheral/vv_edit_var(var_name, new_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, controller_linking))
			return FALSE
	return ..()

/obj/machinery/airlock_peripheral/preloading_instance(with_id)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, with_id)

/obj/machinery/airlock_peripheral/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/airlock_peripheral/LateInitialize()
	. = ..()
	#warn link to controller

#warn impl



