//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/map_helper/airlock_door_linker
	#warn sprite
	late = TRUE

	/// airlock ID to link to; will be automatically mangled
	var/airlock_id

/obj/map_helper/airlock_door_linker/preloading_instance(with_id)
	. = ..()
	if(airlock_id)
		airlock_id = SSmapping.mangled_round_local_id(airlock_id, with_id)

/obj/map_helper/airlock_door_linker/LateInitialize()
	var/obj/machinery/airlock_controller/controller = GLOB.airlock_controllers[airlock_id]
	if(!controller)
		stack_trace("no controller found on id [airlock_id]")
		return ..()
	for(var/obj/machinery/door/door in loc)
		inject_to_controller(controller, door)
	return ..()

/obj/map_helper/airlock_door_linker/proc/inject_to_controller(obj/machinery/airlock_controller/controller, obj/machinery/door/door)
	return

/obj/map_helper/airlock_door_linker/inside

/obj/map_helper/airlock_door_linker/inside/inject_to_controller(obj/machinery/airlock_controller/controller, obj/machinery/door/door)
	LAZYADD(controller.interior, door)

/obj/map_helper/airlock_door_linker/outside

/obj/map_helper/airlock_door_linker/proc/inject_to_controller(obj/machinery/airlock_controller/controller, obj/machinery/door/door)
	LAZYADD(controller.exterior, door)
