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

/datum/machinery_system/occupant_pod/proc/fits_occupant(atom/movable/entity)
	if(!isliving(entity))
		return FALSE
	return TRUE

/datum/machinery_system/occupant_pod/proc/supports_opening()
	return open_state != null

/datum/machinery_system/occupant_pod/proc/is_open()
	return open_state == TRUE

/datum/machinery_system/occupant_pod/proc/is_closed()
	return open_state == FALSE

/datum/machinery_system/occupant_pod/proc/is_occupied()
	return !!occupant

/datum/machinery_system/occupant_pod/proc/user_common_checks(datum/event_args/actor/actor, silent, suppressed)
	if(!actor.performer.Reachability(src))
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("You can't reach [src]!"),
				target = parent,
			)
		return FALSE
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE))
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
		if(!actor.performer.Reachability(inserting))
			if(!silent)
				actor.chat_feedback(
					SPAN_WARNING("You need to be able to reach [inserting] to shove them into [src]."),
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
	if(inserting.is_buckled())
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("[is_self ? "[inserting]" : "You"] must not be buckled."),
				target = inserting,
			)
		return FALSE
	return TRUE

/datum/machinery_system/occupant_pod/proc/user_enter_dragdrop(datum/event_args/actor/actor, silent, suppressed)
	return user_enter(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_enter_context(datum/event_args/actor/actor, silent, suppressed)
	return user_enter(actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_enter(datum/event_args/actor/actor, silent, suppressed)
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	if(!occupant_common_checks(actor.performer, actor, silent, suppressed))
		return FALSE
	#warn impl

/datum/machinery_system/occupant_pod/proc/user_insert_dragdrop(mob/inserting, datum/event_args/actor/actor, silent, suppressed)
	return user_insert(inserting, actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_insert_grab(mob/inserting, datum/event_args/actor/actor, silent, suppressed)
	return user_insert(inserting, actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_insert(mob/inserting, datum/event_args/actor/actor, silent, suppressed)
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	if(!occupant_common_checks(inserting, actor, silent, suppressed))
		return FALSE
	#warn impl; common-ize these?

/datum/machinery_system/occupant_pod/proc/user_eject_click(datum/event_args/actor/actor, silent, suppressed)
	return user_eject(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_eject_context(datum/event_args/actor/actor, silent, suppressed)
	return user_eject(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_eject_resist(datum/event_args/actor/actor, silent, suppressed)
	return user_eject(actor, silent, suppressed)
/datum/machinery_system/occupant_pod/proc/user_eject_move(datum/event_args/actor/actor, silent, suppressed)
	return user_eject(actor, silent, suppressed)

/datum/machinery_system/occupant_pod/proc/user_eject(datum/event_args/actor/actor, silent, suppressed)
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
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	#warn impl

/datum/machinery_system/occupant_pod/proc/user_open(datum/event_args/actor/actor, silent, suppressed)
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	#warn impl

/datum/machinery_system/occupant_pod/proc/user_close(datum/event_args/actor/actor, silent, suppressed)
	if(!user_common_checks(actor, silent, suppressed))
		return FALSE
	#warn impl

/datum/machinery_system/occupant_pod/proc/check_mutable(datum/event_args/actor/actor, silent, suppressed)
	. = TRUE
	if(!parent.machinery_occupant_pod_mutable(src, ., actor, silent, suppressed))
		return FALSE

/**
 * * Implicitly ejects if anyone's inside.
 */
/datum/machinery_system/occupant_pod/proc/open(datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(open_state != FALSE)
		return FALSE

/datum/machinery_system/occupant_pod/proc/on_open(datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)

/datum/machinery_system/occupant_pod/proc/close(datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(open_state != TRUE)
		return FALSE

/datum/machinery_system/occupant_pod/proc/on_close(datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)

/datum/machinery_system/occupant_pod/proc/insert(mob/entity, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(occupant)
		return FALSE

/datum/machinery_system/occupant_pod/proc/on_insert(mob/entity, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)

/datum/machinery_system/occupant_pod/proc/eject(atom/new_loc = host.drop_location(), datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!occupant)
		return FALSE

/datum/machinery_system/occupant_pod/proc/on_eject(mob/entity, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)

#warn impl all

/obj/machinery/proc/machinery_occupant_pod_opened(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/proc/machinery_occupant_pod_closed(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/proc/machinery_occupant_pod_entered(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/proc/machinery_occupant_pod_exited(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/proc/machinery_occupant_pod_accepts(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * Checks if the occupant pod can be interacted with **at all** (including open/close)
 */
/obj/machinery/proc/machinery_occupant_pod_mutable(datum/machinery_system/occupant_pod/pod, pod_opinion, datum/event_args/actor/actor, silent, suppressed)
	SHOULD_NOT_SLEEP(TRUE)

//* -- Lazy init wrapers -- *//

/obj/machinery/proc/init_occupant_pod() as /datum/machinery_system/occupant_pod
	#warn make sure to set eject..

/obj/machinery/proc/init_occupant_pod_openable() as /datum/machinery_system/occupant_pod

#warn impl all
