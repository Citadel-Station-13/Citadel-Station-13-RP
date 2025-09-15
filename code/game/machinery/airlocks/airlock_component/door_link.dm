//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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

/obj/machinery/airlock_component/door_linker/proc/create_state_task(set_opened, set_locked) as /datum/airlock_task

/obj/machinery/airlock_component/door_linker/proc/set_state(opened, locked)
	#warn impl

/obj/machinery/airlock_component/door_linker/indoors
	is_indoors = TRUE

/obj/machinery/airlock_component/door_linker/outdoors
	is_indoors = FALSE

/datum/airlock_task/peripheral/door_linker

/datum/airlock_task/peripheral/door_linker/operate
	var/target_opened
	var/target_locked
	var/backoff_until

/datum/airlock_task/peripheral/door_linker/operate/New(datum/airlock_cycle/cycle, obj/machinery/airlock_component/component, set_opened, set_locked)
	src.target_opened = set_opened
	src.target_locked = set_locked
	return ..()

/datum/airlock_task/peripheral/door_linker/operate/describe_state()
	return "Waiting on linked door"

/datum/airlock_task/peripheral/door_linker/operate/begin()
	poll()

/datum/airlock_task/peripheral/door_linker/operate/poll()
	if(check_airlock())
		complete()
	if(world.time < backoff_until)
		return
	var/obj/machinery/airlock_component/door_linker/linker = component
	linker.set_state(target_opened, target_locked)
	if(check_airlock())
		complete()
	else
		backoff_until = world.time + 2 SECONDS

/datum/airlock_task/peripheral/door_linker/operate/proc/check_airlock()
	if(!isnull(target_opened))
	if(!isnull(target_locked))
	#warn impl all
	return TRUE
