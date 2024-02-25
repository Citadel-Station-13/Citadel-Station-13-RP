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
	/// drop all targets on attack self
	var/drop_all_targets_on_attack_self = TRUE

/obj/item/stream_projector/Destroy()
	drop_all_targets()
	return ..()

/obj/item/stream_projector/on_attack_self(datum/event_args/actor/e_args)
	if(drop_all_targets_on_attack_self && length(active_targets))
		drop_all_targets()
		e_args.chat_feedback(
			SPAN_NOTICE("You disengage [src] from all locked targets."),
			target = src,
		)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
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



