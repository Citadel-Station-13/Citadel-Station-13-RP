//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Generic occupant pod support for machines.
 * * Supports an open/closed state.
 */
/datum/machinery_system/occupant_pod
	/// If non-null, we have open/closed status.
	var/open_state = null

	var/insert_via_dragdrop = TRUE

	var/enter_via_dragdrop = TRUE
	var/enter_via_context = TRUE

	var/eject_via_context = TRUE

	/// occupant
	var/mob/living/occupant

/datum/machinery_system/occupant_pod/proc/fits_occupant(atom/movable/entity)
	if(!isliving(entity))
		return FALSE
	return TRUE



#warn impl

/obj/machinery/proc/machinery_occupant_pod_entered(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent)

/obj/machinery/proc/machinery_occupant_pod_exited(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent)

/obj/machinery/proc/machinery_occupant_pod_accepts(atom/movable/entity, datum/machinery_system/occupant_pod/pod, datum/event_args/actor/actor, silent)

/**
 * Checks if the occupant pod can be interacted with **at all** (including open/close)
 */
/obj/machinery/proc/machinery_occupant_pod_mutable(atom/movable/entity, datum/machinery_system/occupant_pod/pod, pod_opinion, datum/event_args/actor/actor, silent)

//* -- Lazy init wrapers -- *//

/obj/machinery/proc/init_occupant_pod() as /datum/machinery_system/occupant_pod

/obj/machinery/proc/init_occupant_pod_openable() as /datum/machinery_system/occupant_pod

#warn impl all
