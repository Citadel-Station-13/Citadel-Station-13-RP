//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Generic occupant pod support for machines.
 * * Supports an open/closed state.
 */
/datum/machinery_system/occupant_pod
	/// If non-null, we have open/closed status.
	var/open_state = null

	var/insert_via_dragdrop = FALSE
	var/insert_via_grab = FALSE

	var/enter_via_dragdrop = FALSE
	var/enter_via_context = FALSE

	// 'enter via bump' is intentionally left out.
	// generally, automatically entering potentially dangerous machinery via bump
	// unless it's intended to be that kind of hazard is shitty design.
	// as an example, accidentally tapping a movement key shouldn't let you stumble into
	// a sleeper set to 100% stasis or something.

	var/eject_via_context = FALSE
	var/eject_via_click = FALSE
	var/eject_via_resist = FALSE
	var/eject_via_move = FALSE

	var/door_via_click = FALSE
	var/door_via_context = FALSE

	/// occupant
	var/mob/living/occupant

/datum/machinery_system/occupant_pod/Destroy()
	if(occupant)
		// generally, it's invalid behavior to just qdel (presumably) players
		eject(parent, silent = TRUE, suppressed = TRUE)
	return ..()

/datum/machinery_system/occupant_pod/proc/fits_occupant(atom/movable/entity)
	if(!isliving(entity))
		. = FALSE
	. = TRUE
	. = parent.machinery_occupant_pod_accepts(entity, src, null, null, null)

/datum/machinery_system/occupant_pod/proc/supports_opening()
	return open_state != null

/datum/machinery_system/occupant_pod/proc/is_open()
	return open_state == TRUE

/datum/machinery_system/occupant_pod/proc/is_closed()
	return open_state == FALSE

/datum/machinery_system/occupant_pod/proc/is_occupied()
	return !!occupant

/datum/machinery_system/occupant_pod/proc/user_common_checks(datum/event_args/actor/actor, silent, suppressed)
	if(!actor.check_performer_reachability(parent))
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("You can't reach [parent]!"),
				target = parent,
			)
		return FALSE
	if(!CHECK_MOBILITY(actor.performer, MOBILITY_CAN_USE))
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("You can't do that right now."),
				target = parent,
			)
		return FALSE
	return TRUE

/datum/machinery_system/occupant_pod/proc/occupant_common_checks(atom/movable/inserting, datum/event_args/actor/actor, silent, suppressed)
	var/is_self = inserting == actor.performer
	if(!is_self)
		if(!actor.check_performer_reachability(inserting))
			if(!silent)
				actor.chat_feedback(
					SPAN_WARNING("You need to be able to reach [inserting] to shove them into [parent]."),
					target = inserting,
				)
			return FALSE
	if(inserting.anchored)
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("[is_self ? "[inserting] is" : "You are"] anchored to the ground."),
				target = inserting
			)
		return FALSE
	if(inserting.has_buckled_mobs())
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("[is_self ? "[inserting]" : "You"] must not have any buckled mobs."),
				target = inserting,
			)
		return FALSE
	if(ismob(inserting))
		var/mob/casted_mob = inserting
		if(casted_mob.is_buckled())
			if(!silent)
				actor.chat_feedback(
					SPAN_WARNING("[is_self ? "[inserting]" : "You"] must not be buckled."),
					target = inserting,
				)
			return FALSE
	if(!fits_occupant(inserting))
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[is_self ? "[inserting]" : ""] does not fit in [parent]."),
				target = parent,
 			)
		return FALSE
	return TRUE

/datum/machinery_system/occupant_pod/proc/user_enter_dragdrop(datum/event_args/actor/actor, silent, suppressed)
	return user_enter(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_enter_context(datum/event_args/actor/actor, silent, suppressed)
	return user_enter(actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_enter(datum/event_args/actor/actor, silent, suppressed)
	if(!check_mutable(actor, silent, suppressed))
		return FALSE
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	if(!occupant_common_checks(actor.performer, actor, silent, suppressed))
		return FALSE
	return insert(actor.performer, actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_insert_dragdrop(mob/inserting, datum/event_args/actor/actor, silent, suppressed)
	return user_insert(inserting, actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_insert_grab(mob/inserting, datum/event_args/actor/actor, silent, suppressed)
	return user_insert(inserting, actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_insert(mob/inserting, datum/event_args/actor/actor, silent, suppressed)
	if(!check_mutable(actor, silent, suppressed))
		return FALSE
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	if(!occupant_common_checks(inserting, actor, silent, suppressed))
		return FALSE
	return insert(inserting, actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_eject_click(datum/event_args/actor/actor, silent, suppressed)
	return user_eject(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_eject_context(datum/event_args/actor/actor, silent, suppressed)
	return user_eject(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_eject_resist(datum/event_args/actor/actor, silent, suppressed)
	return user_eject(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_eject_move(datum/event_args/actor/actor, silent, suppressed)
	return user_eject(actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_eject(datum/event_args/actor/actor, silent, suppressed)
	if(!check_mutable(actor, silent, suppressed))
		return FALSE
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	if(!check_mutable(actor, silent, suppressed))
		return FALSE
	return eject(null, actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_toggle_click(datum/event_args/actor/actor, silent, suppressed)
	return user_toggle(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_toggle_context(datum/event_args/actor/actor, silent, suppressed)
	return user_toggle(actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_toggle(datum/event_args/actor/actor, silent, suppressed)
	// ignore open state being null it'll be handled on user open/close
	if(open_state)
		return user_close(actor, silent, suppressed)
	else
		return user_open(actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_open(datum/event_args/actor/actor, silent, suppressed)
	if(!check_mutable(actor, silent, suppressed))
		return FALSE
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	return open(actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_close(datum/event_args/actor/actor, silent, suppressed)
	if(!check_mutable(actor, silent, suppressed))
		return FALSE
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	return close(actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/check_mutable(datum/event_args/actor/actor, silent, suppressed, ejecting)
	. = TRUE
	if(!parent.machinery_occupant_pod_mutable(src, ., actor, silent, suppressed, ejecting))
		return FALSE

/**
 * * Implicitly ejects if anyone's inside.
 */
/datum/machinery_system/occupant_pod/proc/open(datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	switch(open_state)
		if(null)
			if(!silent)
				actor?.chat_feedback(
					SPAN_WARNING("[parent] doesn't support being opened / closed. How did you get here?"),
					target = parent,
				)
			return FALSE
		if(TRUE)
			if(!silent)
				actor?.chat_feedback(
					SPAN_WARNING("[parent] is already open."),
					target = parent,
				)
			return FALSE
	eject(parent.drop_location(), actor, TRUE, TRUE)
	open_state = TRUE
	parent.machinery_occupant_pod_opened(src, actor, silent, suppressed)
	on_open(actor, silent, suppressed)
	return TRUE

/datum/machinery_system/occupant_pod/proc/on_open(datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	parent.machinery_occupant_pod_opened(src, actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/close(datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	switch(open_state)
		if(null)
			if(!silent)
				actor?.chat_feedback(
					SPAN_WARNING("[parent] doesn't support being opened / closed. How did you get here?"),
					target = parent,
				)
			return FALSE
		if(FALSE)
			if(!silent)
				actor?.chat_feedback(
					SPAN_WARNING("[parent] is already closed."),
					target = parent,
				)
			return FALSE
	open_state = FALSE
	parent.machinery_occupant_pod_closed(src, actor, silent, suppressed)
	on_close(actor, silent, suppressed)
	return TRUE

/datum/machinery_system/occupant_pod/proc/on_close(datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	parent.machinery_occupant_pod_closed(src, actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/insert(mob/entity, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(occupant)
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[parent] already has someone occupying it."),
				target = parent,
			)
		return FALSE

	log_game("[key_name(entity)] entered occupant pod of [parent] ([REF(parent)]) by [actor ? actor.actor_log_string() : "-no actor-"]")

	// TODO: contents holder separate from parent maybe?
	entity.forceMove(parent)
	occupant = entity
	entity.update_perspective()

	if(!suppressed && actor)
		if(entity == actor.performer)
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_COMBAT_SUBTLE,
				visible = SPAN_NOTICE("[actor.performer] climbs into [parent]."),
			)
		else
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_COMBAT_SUBTLE,
				visible = SPAN_WARNING("[actor.performer] puts [entity] into [parent]."),
			)
	on_insert(entity, actor, silent, suppressed)
	return TRUE

/datum/machinery_system/occupant_pod/proc/on_insert(mob/entity, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	parent.machinery_occupant_pod_entered(entity, src, actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/eject(atom/new_loc = parent.drop_location(), datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!occupant)
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[parent] doesn't have anyone occupying it."),
				target = parent,
			)
		return FALSE

	log_game("[key_name(entity)] ejected from occupant pod of [parent] ([REF(parent)]) by [actor ? actor.actor_log_string() : "-no actor-"]")

	var/mob/living/ejecting = occupant
	occupant = null
	// TODO: contents holder separate from parent maybe?
	if(ejecting.loc == parent)
		ejecting.forceMove(new_loc)
		ejecting.update_perspective()

	if(!suppressed && actor)
		if(ejecting == actor.performer)
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_COMBAT_SUBTLE,
				visible = SPAN_NOTICE("[actor.performer] pops out of [parent]."),
			)
		else
			actor.visible_feedback(
				target = src,
				range = MESSAGE_RANGE_COMBAT_SUBTLE,
				visible = SPAN_WARNING("[actor.performer] pulls [ejecting] out of [parent]."),
			)
	on_eject(ejecting, actor, silent, suppressed)
	return TRUE

/datum/machinery_system/occupant_pod/proc/on_eject(mob/entity, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	parent.machinery_occupant_pod_exited(entity, src, actor, silent, suppressed)

/obj/machinery/proc/machinery_occupant_pod_opened(datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/proc/machinery_occupant_pod_closed(datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/proc/machinery_occupant_pod_entered(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/proc/machinery_occupant_pod_exited(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/proc/machinery_occupant_pod_accepts(atom/movable/entity, datum/machinery_system/occupant_pod/pod, pod_opinion, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return TRUE

/**
 * Checks if the occupant pod can be interacted with **at all** (including open/close)
 * * Ejecting is a special arg as trapping people inside during eject is not necessarily a good thing.
 */
/obj/machinery/proc/machinery_occupant_pod_mutable(datum/machinery_system/occupant_pod/pod, pod_opinion, datum/event_args/actor/actor, silent, suppressed, ejecting)
	SHOULD_NOT_SLEEP(TRUE)
	return TRUE

//* -- Lazy init wrapers -- *//

/obj/machinery/proc/init_occupant_pod() as /datum/machinery_system/occupant_pod
	if(!machine_occupant_pod)
		machine_occupant_pod = new(src)
	return machine_occupant_pod

/obj/machinery/proc/init_occupant_pod_default() as /datum/machinery_system/occupant_pod
	var/datum/machinery_system/occupant_pod/pod = init_occupant_pod()
	pod.insert_via_dragdrop = TRUE
	pod.insert_via_grab = TRUE
	pod.enter_via_context = TRUE
	pod.enter_via_dragdrop = TRUE
	pod.eject_via_context = TRUE
	pod.eject_via_resist = TRUE
	pod.eject_via_move = TRUE
	pod.eject_via_click = TRUE
	return pod

/obj/machinery/proc/init_occupant_pod_default_openable(start_opened) as /datum/machinery_system/occupant_pod
	var/datum/machinery_system/occupant_pod/pod = init_occupant_pod_default()
	pod.door_via_click = TRUE
	pod.door_via_context = TRUE
	pod.open_state = start_opened
	return pod
