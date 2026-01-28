//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Default airlock program. Can handle quite a lot, but not everything.
 */
/datum/airlock_program/vacuum_cycle
	tgui_airlock_component = "VacuumCycle"

/datum/airlock_program/vacuum_cycle/ui_program_data(datum/airlock_system/system)
	. = ..()
	.["interiorSealed"] = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_SEALED]
	.["exteriorSealed"] = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_SEALED]

/datum/airlock_program/vacuum_cycle/ui_program_act(datum/airlock_system/system, datum/event_args/actor/actor, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		#warn vacuum cycle
		if("cycleToExterior")
		if("cycleToInterior")
		#warn abort cycles and force doors based on states
		if("forceExteriorDoors")
		if("forceInteriorDoors")
		if("cancel")
			// soft cancel, try to repressurize
		if("abort")
			// immediate abort

/datum/airlock_program/vacuum_cycle/proc/get_currently_open_side(datum/airlock_system/system)
	return system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE]

/datum/airlock_program/vacuum_cycle/proc/set_currently_open_side(datum/airlock_system/system, side)
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE] = side

#warn impl

#warn tgui
