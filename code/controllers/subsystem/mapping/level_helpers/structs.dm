//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Gets the /datum/world_struct of a zlevel or id
 */
/datum/controller/subsystem/mapping/proc/level_struct_datum(id_or_z)
	#warn impl

/**
 * ensures that a level has a struct; make one with just that level at 0, 0, 0, if needed
 *
 * returns existing OR new struct
 */
/datum/controller/subsystem/mapping/proc/level_ensure_struct(z)
	RETURN_TYPE(/datum/world_struct)
	#warn impl
