//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/component/kinetic_destabilization
	registered_type = /datum/component/kinetic_destabilization
	can_transfer = TRUE

	/// source to timerid
	var/list/stacks = list()

/datum/component/kinetic_destabilization/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

/datum/component/kinetic_destabilization/Destroy()
	stacks = null
	return ..()

/datum/component/kinetic_destabilization/PostTransfer()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/kinetic_destabilization/proc/apply_stack(source, duration)
	var/existing
	if((existing = stacks[source]) && existing != "permanent")
		deltimer(existing)

	if(duration)
		stacks[source] = addtimer(CALLBACK(src, PROC_REF(remove_stack), source), TIMER_STOPPABLE)
	else
		stacks[source] = "permanent"

/datum/component/kinetic_destabilization/proc/remove_stack(source)
	if(!stacks[source])
		return
	stacks -= source
	if(!length(stacks))
		qdel(src)
	else
		update_visuals()

/**
 * @return TRUE if stack was there, FALSE otherwise
 */
/datum/component/kinetic_destabilization/proc/consume_stack(source)
	if(!stacks[source])
		return FALSE
	remove_stack(source)
	stacks -= source
	return TRUE

/**
 * @return stacks used
 */
/datum/component/kinetic_destabilization/proc/detonate()
	. = length(stacks)
	qdel(src)

/datum/component/kinetic_destabilization/proc/update_visuals()
	var/atom/movable/parent_movable = parent

#warn impl

//* Wrapper procs for easy usage without needing boilerplate of loadcomponent. *//

/atom/movable/proc/kinetic_destabilization_apply(source, duration)
	var/datum/component/kinetic_destabilization/comp = LoadComponent(/datum/component/kinetic_destabilization)
	comp.apply_stack(source, duration)

/atom/movable/proc/kinetic_destabilization_consume(source)
	var/datum/component/kinetic_destabilization/comp = GetComponent(/datum/component/kinetic_destabilization)
	if(!comp)
		return FALSE
	return comp.consume_stack(source)

/atom/movable/proc/kinetic_destabilization_detonate()
	var/datum/component/kinetic_destabilization/comp = GetComponent(/datum/component/kinetic_destabilization)
	if(!comp)
		return 0
	return comp.detonate()
