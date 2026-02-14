//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * * Stateful.
 */
/datum/airlock_task
	/// cycling we belong to, if any
	var/datum/airlock_cycling/cycling
	/// completed?
	var/completed = FALSE
	/// started at time
	var/started_at

/datum/airlock_task/New()
	started_at = world.time

/datum/airlock_task/Destroy()
	if(cycling)
		cycling.remove_task(src)
		cycling = null
	return ..()

/datum/airlock_task/proc/component_still_valid(obj/machinery/airlock_component/component)
	if(QDELETED(component) || !component.network)
		return FALSE
	if(component.network != cycling.system.controller?.network)
		return FALSE
	return TRUE

/datum/airlock_task/proc/assign_cycle(datum/airlock_cycling/cycling)
	ASSERT(!src.cycling)
	src.cycling = cycling
	src.cycling.running_tasks += src

/datum/airlock_task/proc/unassign_cycle(datum/airlock_cycling/cycling)
	ASSERT(src.cycling == cycling)
	src.cycling = null
	cycling.running_tasks -= src

/datum/airlock_task/proc/ui_task_data()
	return list(
		"startedAt" = started_at,
		"reason" = describe_state(),
	)

/datum/airlock_task/proc/describe_state()
	return "-- unknown task --"

/**
 * this should both do things and check for completion
 */
/datum/airlock_task/proc/poll(dt)
	return

/datum/airlock_task/proc/complete()
	completed = TRUE

/datum/airlock_task/proc/fail()
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

/datum/airlock_task/compound
	var/list/datum/airlock_task/tasks

/datum/airlock_task/compound/New(list/datum/airlock_task/tasks)
	src.tasks = tasks
	..()

/datum/airlock_task/compound/Destroy()
	QDEL_LIST(tasks)
	return ..()

/datum/airlock_task/compound/poll(dt)
	for(var/datum/airlock_task/task as anything in tasks)
		task.poll()

/datum/airlock_task/compound/complete()
	for(var/datum/airlock_task/task as anything in tasks)
		task.complete()
