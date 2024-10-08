//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// todo: buildable

/**
 * Door Linker
 *
 * * Used to link the airlock to doors.
 */
/obj/machinery/airlock_component/door_linker
	#warn impl

	/// are we indoors? if not, we're outdoors
	var/is_indoors = FALSE
	/// linked door, if any
	var/obj/machinery/door/door

#warn impl

/obj/machinery/airlock_comopnent/door_linker/proc/set_state(opened, locked)
	#warn impl

/obj/machinery/airlock_component/door_linker/indoors
	is_indoors = TRUE

/obj/machinery/airlock_component/door_linker/outdoors
	is_indoors = FALSE
