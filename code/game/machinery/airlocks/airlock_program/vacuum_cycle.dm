//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Default airlock program. Can handle quite a lot, but not everything.
 */
/datum/airlock_program/vacuum_cycle
	tgui_airlock_component = "VacuumCycle"

	/**
	 * Every this-much time, we will check if our doors are 'correct'.
	 * If not, the airlock is activated to shut the doors, if possible.
	 * This allows airlocks to be self-repairing to an extent.
	 */
	var/reassert_doors_every = 90 SECONDS
	var/reassert_doors_last

/datum/airlock_program/vacuum_cycle/ui_program_data(datum/airlock_system/system)
	. = ..()
	.["interiorSealed"] = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_INTERIOR_DOOR_SEALED]
	.["exteriorSealed"] = system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_EXTERIOR_DOOR_SEALED]

/datum/airlock_program/vacuum_cycle/ui_program_act(datum/airlock_system/system, datum/event_args/actor/actor, action, list/params)
	. = ..()
	if(.)
		return
	#warn vacuum cycle
	switch(action)
		if("cycleToExterior")
			pass()
		if("cycleToInterior")
			#warn abort cycles and force doors based on states
			pass()
		if("forceExteriorDoors")
			pass()
		if("forceInteriorDoors")
			pass()
		if("cancel")
			pass()
			// soft cancel, try to repressurize
		if("abort")
			pass()
			// immediate abort

/datum/airlock_program/vacuum_cycle/proc/get_currently_open_side(datum/airlock_system/system)
	return system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE]

/datum/airlock_program/vacuum_cycle/proc/set_currently_open_side(datum/airlock_system/system, side)
	system.blackboard[AIRLOCK_SYSTEM_BLACKBOARD_CURRENT_SIDE] = side

#warn impl

#warn tgui
