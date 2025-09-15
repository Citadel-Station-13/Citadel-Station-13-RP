//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/airlock_task
	/// cycle we belong to, if any
	var/datum/airlock_cycle/cycle
	/// completed?
	var/completed = FALSE
	/// started at time
	var/started_at

/datum/airlock_task/New()
	started_at = world.time

/datum/airlock_task/Destroy()
	if(cycle)
		cycle.remove_task(src)
	return ..()

/datum/airlock_task/proc/assign_cycle(datum/airlock_cycle/cycle)
	ASSERT(!src.cycle)
	src.cycle = cycle
	src.cycle.running_tasks += src

/datum/airlock_task/proc/unassign_cycle(datum/airlock_cycle/cycle)
	ASSERT(src.cycle == cycle)
	cycle.running_tasks -= src
	cycle = null

/datum/airlock_task/proc/ui_task_data()
	return list(
		"startedAt" = started_at,
		"completed" = completed,
		"reason" = describe_state(),
	)

/datum/airlock_task/proc/describe_state()
	return "-- unknown task --"

/**
 * this should both do things and check for completion
 */
/datum/airlock_task/proc/poll()
	return

/datum/airlock_task/proc/complete()
	completed = TRUE

/datum/airlock_task/component
	/// component ref
	var/obj/machinery/airlock_component/component

/datum/airlock_task/component/New(obj/machinery/airlock_component/component)
	..()
	src.component = component

/datum/airlock_task/component/Destroy()
	component = null
	return ..()
