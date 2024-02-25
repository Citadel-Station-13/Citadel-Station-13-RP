//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * base supertype of stream projection devices
 *
 * e.g. mediguns
 */
/obj/item/stream_projector
	#warn impl

	/// locked targets
	var/list/atom/active_targets

/obj/item/stream_projector/Destroy()
	drop_all_targets()
	return ..()

/obj/item/stream_projector/proc/valid_target(atom/entity)
	return istype(entity)

/obj/item/stream_projector/proc/can_target(atom/entity)
	return TRUE

/obj/item/stream_projector/proc/lock_target(atom/entity)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(active_targets?[entity])
		return FALSE
	LAZYSET(active_targets, entity, TRUE)
	#warn impl

/**
 * do target removal logic here
 */
/obj/item/stream_projector/proc/on_target_add(atom/entity)
	return

/**
 * do target removal logic here
 */
/obj/item/stream_projector/proc/on_target_remove(atom/entity)
	return

/obj/item/stream_projector/proc/try_lock_target(atom/entity, datum/event_args/actor/actor, silent)

/obj/item/stream_projector/proc/drop_target(atom/entity)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!active_targets?[entity])
		return FALSE
	LAZYREMOVE(active_targets, entity)
	#warn impl

/obj/item/stream_projector/proc/drop_all_targets()
	for(var/atom/entity as anything in active_targets)
		drop_target(entity)

#warn impl all



