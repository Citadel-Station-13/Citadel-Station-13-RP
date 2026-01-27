//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/airlock_component/door_linker
	name = /obj/machinery/airlock_component/door_linker::name + " (detached)"
	desc = /obj/machinery/airlock_component/door_linker::desc
	machine_type = /obj/machinery/airlock_component/door_linker
	icon = /obj/machinery/airlock_component/door_linker::icon
	icon_state = /obj/machinery/airlock_component/door_linker::icon_state
	base_icon_state = /obj/machinery/airlock_component/door_linker::base_icon_state

	var/is_indoors = FALSE

/obj/item/airlock_component/door_linker/Initialize(mapload, set_dir, obj/machinery/airlock_component/door_linker/from_machine)
	if(from_machine)
		src.is_indoors = from_machine.is_indoors
	return ..()

/obj/item/airlock_component/door_linker/on_attack_self(datum/event_args/actor/e_args)
	is_indoors = !is_indoors
	// TODO: log
	e_args.chat_feedback(
		SPAN_NOTICE("You set [src] to bind to an airlock's [is_indoors ? "interior" : "exterior"] side."),
		target = src,
	)
	return CLICKCHAIN_DID_SOMETHING

/obj/item/airlock_component/door_linker/indoors
	is_indoors = TRUE

/obj/item/airlock_component/door_linker/outdoors
	is_indoors = FALSE

/**
 * Door Linker
 *
 * * Used to link the airlock to doors.
 */
/obj/machinery/airlock_component/door_linker
	name = "airlock door linker"
	desc = "An underfloor controller for a full cycling airlock. This will control doors placed above it."
	icon = 'icons/machinery/airlocks/airlock_doorlink.dmi'
	icon_state = "doorlink"
	base_icon_state = "doorlink"

	detached_item_type = /obj/item/airlock_component/door_linker

	/// are we indoors? if not, we're outdoors
	var/is_indoors = FALSE

/obj/machinery/airlock_component/door_linker/Initialize(mapload, set_dir, obj/item/airlock_component/door_linker/from_item)
	if(from_item)
		src.is_indoors = from_item.is_indoors
	return ..()

/obj/machinery/airlock_component/door_linker/proc/set_is_indoors(new_is_indoors)
	src.is_indoors = new_is_indoors

/obj/machinery/airlock_component/door_linker/proc/create_state_task(set_opened, set_locked) as /datum/airlock_task
	return new /datum/airlock_task/component/door_linker/operate(src, set_opened, set_locked)

/obj/machinery/airlock_component/door_linker/proc/get_airlock() as /obj/machinery/door/airlock
	return locate(/obj/machinery/door/airlock) in loc

/**
 * @return TRUE if immediately successful, FALSE of failed or must sleep
 */
/obj/machinery/airlock_component/door_linker/proc/set_state(opened, locked)
	SHOULD_NOT_SLEEP(TRUE)

	var/obj/machinery/door/airlock/maybe_airlock = get_airlock()
	// if we want to set opened, handle that first
	if(!isnull(opened) && (maybe_airlock.density != opened))
		// try to operate
		if(!maybe_airlock.unlock())
			return FALSE
		if(opened)
			ASYNC
				maybe_airlock.open()
		else
			ASYNC
				maybe_airlock.close()
		// open / close has delay
		return FALSE
	// then, see if we need to be locked
	if(!isnull(locked) && (maybe_airlock.locked != locked))
		if(maybe_airlock.locked && !locked)
			maybe_airlock.unlock()
		else if(!maybe_airlock.locked && locked)
			maybe_airlock.lock()
		if(maybe_airlock.locked != locked)
			return FALSE
	return TRUE

/obj/machinery/airlock_component/door_linker/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_component/door_linker/indoors
	is_indoors = TRUE

/obj/machinery/airlock_component/door_linker/indoors/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/obj/machinery/airlock_component/door_linker/outdoors
	is_indoors = FALSE

/obj/machinery/airlock_component/door_linker/outdoors/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/datum/airlock_task/component/door_linker

/datum/airlock_task/component/door_linker/operate
	var/target_opened
	var/target_locked
	var/backoff_until

/datum/airlock_task/component/door_linker/operate/New(obj/machinery/airlock_component/component, set_opened, set_locked)
	src.target_opened = set_opened
	src.target_locked = set_locked
	return ..()

/datum/airlock_task/component/door_linker/operate/describe_state()
	return "Waiting on linked door"

/datum/airlock_task/component/door_linker/operate/poll(dt)
	if(world.time < backoff_until)
		return
	var/obj/machinery/airlock_component/door_linker/linker = component
	if(!component_still_valid(linker))
		fail()
		return
	if(linker.set_state(target_opened, target_locked))
		complete()
	else
		backoff_until = world.time + 2 SECONDS
