//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * base supertype of stream projection devices
 *
 * e.g. mediguns
 *
 * processing uses SSprocessing.
 */
/obj/item/stream_projector
	abstract_type = /obj/item/stream_projector
	/// locked targets; associated value must be truthy but is reserved by visual construction.
	var/list/atom/active_targets
	/// drop all targets on attack self
	var/drop_all_targets_on_attack_self = TRUE
	/// process while active
	var/process_while_active = FALSE
	/// process always
	var/process_always = FALSE

/obj/item/stream_projector/Initialize(mapload)
	. = ..()
	if(process_always)
		START_PROCESSING(SSprocessing, src)

/obj/item/stream_projector/Destroy()
	drop_all_targets()
	if(datum_flags & DF_ISPROCESSING)
		STOP_PROCESSING(SSprocessing, src)
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

/obj/item/stream_projector/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	// flatly don't emit the attack if not in harm
	if(intent == INTENT_HARM)
		return ..()
	return NONE

/obj/item/stream_projector/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!valid_target(target))
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(active_targets?[target])
		try_drop_target(target, new /datum/event_args/actor(user))
	else
		try_lock_target(target, new /datum/event_args/actor(user))

/**
 * used to potentially redirect target before lock-on completes; useful for things like holofabricators
 */
/obj/item/stream_projector/proc/transform_target_lock(atom/target)
	return target

/obj/item/stream_projector/process(delta_time)
	return // don't process_kill by default

/**
 * checks if a target is valid to be locked at all
 */
/obj/item/stream_projector/proc/valid_target(atom/entity)
	return istype(entity)

/**
 * checks if we currently can lock onto a target
 */
/obj/item/stream_projector/proc/can_target(atom/entity, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * immediately lock to target
 */
/obj/item/stream_projector/proc/lock_target(atom/entity)
	SHOULD_NOT_OVERRIDE(TRUE)
	entity = transform_target_lock(entity)
	if(isnull(entity))
		return FALSE
	if(active_targets?[entity])
		return FALSE
	LAZYSET(active_targets, entity, TRUE)
	setup_target_visuals(entity)
	on_target_add(entity)
	if(process_while_active && !process_always)
		// START_PROCESSING checks for DF_ISPROCESSING already
		START_PROCESSING(SSprocessing, src)
	if(ismovable(entity))
		RegisterSignal(entity, COMSIG_MOVABLE_MOVED, PROC_REF(on_target_moved))
	return TRUE

/**
 * setup visuals to target
 */
/obj/item/stream_projector/proc/setup_target_visuals(atom/entity)
	return

/**
 * teardown visuals to target
 */
/obj/item/stream_projector/proc/teardown_target_visuals(atom/entity)
	return

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

/**
 * this proc should include all instant checks
 */
/obj/item/stream_projector/proc/try_lock_target(atom/entity, datum/event_args/actor/actor, silent)
	// check if we're already locking that target
	if(active_targets?[entity])
		return FALSE

	// check if it's remotely the right type
	if(!valid_target(entity))
		return FALSE

	// check if we can target
	if(!can_target(entity, actor, silent))
		return FALSE

	if(!perform_try_lock_target(entity, actor, silent))
		return FALSE

	return lock_target(entity)

/**
 * this proc can block and should include blocking checks
 */
/obj/item/stream_projector/proc/perform_try_lock_target(atom/entity, datum/event_args/actor/actor, silent)
	return TRUE

/obj/item/stream_projector/proc/try_drop_target(atom/entity, datum/event_args/actor/actor, silent)
	return drop_target(entity)

/obj/item/stream_projector/proc/drop_target(atom/entity)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!active_targets?[entity])
		return FALSE
	teardown_target_visuals(entity)
	on_target_remove(entity)
	LAZYREMOVE(active_targets, entity)
	if(ismovable(entity))
		UnregisterSignal(entity, COMSIG_MOVABLE_MOVED)
	if(!length(active_targets) && process_while_active && !process_always)
		STOP_PROCESSING(SSprocessing, src)
	return TRUE

/obj/item/stream_projector/proc/on_target_moved(atom/movable/source)
	// notice how we specifically don't check for being on a turf
	// if you want that, you have to check on subtypes (or add a var to base type later)
	if(get_z(source) != get_z(src))
		drop_target(source)

/obj/item/stream_projector/proc/drop_all_targets()
	for(var/atom/entity as anything in active_targets)
		drop_target(entity)
