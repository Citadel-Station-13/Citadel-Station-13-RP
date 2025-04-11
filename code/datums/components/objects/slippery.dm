//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

/**
 * /obj only
 *
 * * too inefficient for /turf
 * * not complex enough for /mob
 *
 * todo: multi-tile object support
 */
/datum/component/slippery
	registered_type = /datum/component/slippery

	var/slip_class = SLIP_CLASS_WATER
	var/hard_strength = 5
	var/soft_strength = 10

/datum/component/slippery/Initialize(slip_class, hard_strength, soft_strength)
	if(!isobj(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

	if(!isnull(slip_class))
		src.slip_class = slip_class
	if(!isnull(hard_strength))
		src.hard_strength = hard_strength
	if(!isnull(soft_strength))
		src.soft_strength = soft_strength

/datum/component/slippery/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
	if(isturf(parent:loc))
		RegisterSignal(parent:loc, COMSIG_ATOM_ENTERED, PROC_REF(on_enter))

/datum/component/slippery/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	if(isturf(parent:loc))
		UnregisterSignal(parent:loc, COMSIG_ATOM_ENTERED)

/datum/component/slippery/proc/on_move(atom/movable/source, atom/old_loc)
	var/atom/new_loc = source.loc
	if(old_loc == new_loc)
		return
	if(isturf(old_loc))
		UnregisterSignal(old_loc, COMSIG_ATOM_ENTERED)
	if(isturf(new_loc))
		RegisterSignal(new_loc, COMSIG_ATOM_ENTERED, PROC_REF(on_enter))

/datum/component/slippery/proc/on_enter(turf/source, atom/movable/entering, atom/old_loc)
	if(source == parent)
		return
	// no more locker exploit
	// basically, don't slip if they're exiting onto the tile we're on
	if(old_loc?.loc == parent:loc)
		return
	if(!isliving(entering))
		return
	var/mob/living/living_entering = entering
	// todo: refactor these
	if(living_entering.is_incorporeal())
		return
	if(living_entering.resting)
		return
	if(!(living_entering.movement_type & MOVEMENT_GROUND) || living_entering.is_avoiding_ground())
		return
	// end

	// check for yanks
	spawn(0)
		if(living_entering.loc == source)
			living_entering.slip_act(slip_class, parent, hard_strength, soft_strength)
