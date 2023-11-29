//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_BOILERPLATE(all_portals, /obj/effect/bluespace_portal)

/**
 * makes a pair of portals with absolute status
 * usually used for legacy purposes
 *
 * @return list(portal A, portal B)
 */
/proc/lazy_bluespace_portal_pair(turf/source, turf/destination, instability, duration = 30 SECONDS, icon_base, name_base)
	var/datum/bluespace_teleport/teleport = new
	teleport.source = source
	teleport.destination = destination
	teleport.instability = instability
	teleport.absolute = TRUE
	teleport.icon_base = icon_base
	teleport.name_base = name_base
	return bluespace_portal_pair(teleport)

/**
 * makes a pair of portals from a given teleportation datum
 *
 * @return list(portal A, portal B)
 */
/proc/bluespace_portal_pair(datum/bluespace_teleport/teleportation, duration = 30 SECONDS)
	var/obj/effect/bluespace_portal/A = new(teleportation.source, teleportation, TRUE)
	var/obj/effect/bluespace_portal/B = new(teleportation.destination, teleportation, FALSE)
	QDEL_IN(A, 30 SECONDS)
	QDEL_IN(B, 30 SECONDS)
	return list(A, B)

/**
 * makes a portal to a destination
 * usually used for legacy purposes
 *
 * @return portal created
 */
/proc/lazy_bluespace_portal_single(turf/where, turf/target, instability, duration = 30 SECONDS, icon_base, name_base)
	var/datum/bluespace_teleport/teleport = new
	teleport.source = where
	teleport.destiantion = target
	teleport.instability = instability
	teleport.absolute = TRUE
	teleport.icon_base = icon_base
	teleport.name_base = name_base
	return new /obj/effect/bluespace_portal(where, teleport, TRUE)

/obj/effect/bluespace_portal
	name = "portal"
	desc = "A semi-stable conduit through bluespace. Surely this can't be a bad idea."
	#warn sprite
	anchored = TRUE

	/// teleport datum
	var/datum/bluespace_teleport/teleportation
	/// are we source or dest?
	var/is_source_side

/obj/effect/bluespace_portal/Initialize(mapload, datum/bluespace_teleport/teleport_datum, is_source)
	. = ..()
	ASSERT(istype(teleport_datum))
	AddElement(/datum/element/connect_loc, list(COMSIG_ATOM_ENTERED, TYPE_PROC_REF(/obj/effect/bluespace_portal, on_enter)))
	src.teleportation = teleport_datum
	src.is_source_side = is_source
	LAZYADD(src.teleportation.portals, src)

/obj/effect/bluespace_portal/Destroy()
	LAZYREMOVE(teleportation.portals, src)
	return ..()

/obj/effect/bluespace_portal/proc/on_enter(datum/source, atom/movable/what, atom/oldloc)
	if(oldloc == (is_source_side? teleportation.destination : teleportation.source))
		return // no loops
	teleport(what, TRUE)

/obj/effect/bluespace_portal/attack_hand(mob/user, list/params)
	user.forceMove(get_turf(src))
	return TRUE

/obj/effect/bluespace_portal/proc/teleport(atom/movable/target, crossed)
	if(target.atom_flags & ATOM_ABSTRACT)
		return FALSE
	if(target.anchored)
		return FALSE
	teleportation.translate_movable(target, is_source_side? teleportation.destination : teleportation.source)
