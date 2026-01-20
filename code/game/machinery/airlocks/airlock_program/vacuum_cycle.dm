//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Default airlock program. Can handle quite a lot, but not everything.
 */
/datum/airlock_program/vacuum_cycle
	tgui_airlock_component = "VacuumCycle"

/datum/airlock_program/vacuum_cycle/ui_program_data()

/datum/airlock_program/vacuum_cycle/ui_program_act(datum/airlock_gasnet/network, datum/event_args/actor/actor, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("cycleToExterior")
		if("cycleToInterior")
		if("forceToExterior")
		if("forceToInterior")
		if("cancel")
			// soft cancel, try to repressurize
		if("abort")
			// immediate abort

/datum/airlock_program/vacuum_cycle/proc/ui_config_standard_reject(datum/airlock_gasnet/network, datum/event_args/actor/actor)
	#warn reject if operating

/datum/airlock_program/vacuum_cycle/tick_cycle(datum/airlock_cycle/cycle, datum/airlock_gasnet/network)
	// vacuum mode //

#warn impl

#warn tgui
