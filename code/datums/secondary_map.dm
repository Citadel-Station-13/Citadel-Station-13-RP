//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Used to render a specific thing, and everything around it, in a secondary view.
 */
/datum/secondary_map
	var/map_id

/datum/secondary_map/New(map_id)
	src.map_id = map_id

/datum/secondary_map/Destroy()
	#warn impl
	return ..()

/datum/secondary_map/proc/update_view()

/datum/secondary_map/proc/get_relevant_turfs() as /list
	return list()

/datum/secondary_map/proc/grant_to_user(mob/user)

/datum/secondary_map/proc/revoke_from_user(mob/user)


#warn impl

/**
 * A secondary map that follows an atom around, showing everything around it in a radius.
 */
/datum/secondary_map/follow_entity_with_radius
	var/atom/movable/entity
	var/radius = 2
	var/move_queued = FALSE

/datum/secondary_map/follow_entity_with_radius/New(map_id, atom/movable/entity, radius)
	..()
	if(!isnull(radius))
		src.radius = radius
	if(!isnull(entity))
		src.set_entity(entity)

/datum/secondary_map/follow_entity_with_radius/Destroy()
	unset_entity()
	return ..()

/datum/secondary_map/follow_entity_with_radius/get_relevant_turfs()
	var/turf/entity_turf = get_turf(entity)
	if(!entity_turf)
		return list()
	var/use_radius = radius
	return RANGE_TURFS(use_radius, entity_turf)

/datum/secondary_map/follow_entity_with_radius/proc/on_entity_moved()
	if(move_queued)
		return
	queue_update()

/datum/secondary_map/follow_entity_with_radius/proc/queue_update()
	if(move_queued)
		return
	move_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(update_queued)))

/datum/secondary_map/follow_entity_with_radius/proc/update_queued()
	move_queued = FALSE
	update_view()

/datum/secondary_map/follow_entity_with_radius/proc/on_entity_del(datum/source)
	if(source == entity)
		unset_entity()

/datum/secondary_map/follow_entity_with_radius/proc/set_entity(atom/movable/new_entity)
	if(entity)
		unset_entity()
	if(!new_entity)
		return
	RegisterSignal(new_entity, COMSIG_PARENT_QDELETING, PROC_REF(on_entity_del))
	RegisterSignal(new_entity, COMSIG_MOVABLE_MOVED, PROC_REF(on_entity_moved))
	entity = new_entity
	update_view()

/datum/secondary_map/follow_entity_with_radius/proc/unset_entity()
	if(!entity)
		return
	UnregisterSignal(entity, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MOVED))
	entity = null
	update_view()

/datum/secondary_map/follow_entity_with_radius/proc/set_radius(new_radius)
	radius = new_radius
	update_view()

/**
 * Renders an entire shuttle, centered on the shuttle itself.
 */
/datum/secondary_map/render_entire_shuttle
	var/border_radius = 3
	var/datum/shuttle/target
	var/update_queued = FALSE

/datum/secondary_map/render_entire_shuttle/New(map_id, datum/shuttle/target, border_radius)
	..()
	if(!isnull(border_radius))
		src.border_radius = border_radius
	if(!isnull(target))
		src.set_target(target)

/datum/secondary_map/render_entire_shuttle/Destroy()
	unset_target()
	return ..()

/datum/secondary_map/render_entire_shuttle/get_relevant_turfs()
	if(!target)
		return list()

/datum/secondary_map/render_entire_shuttle/proc/on_target_anchor_moved()
	queue_update()

/datum/secondary_map/render_entire_shuttle/proc/queue_update()
	if(update_queued)
		return
	update_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(update_queued)))

/datum/secondary_map/render_entire_shuttle/proc/update_queued()
	update_queued = FALSE
	update_view()

/datum/secondary_map/render_entire_shuttle/proc/on_target_del(datum/source)
	if(source == target)
		unset_target()

/datum/secondary_map/render_entire_shuttle/proc/set_target(datum/shuttle/new_target)
	if(target)
		unset_target()
	if(!new_target)
		return
	RegisterSignal(new_target, COMSIG_QDELETING, PROC_REF(on_target_del))
	target = new_target
	if(target.anchor)
		RegisterSignal(target.anchor, COMSIG_SHUTTLE_ANCHOR_MOVED, PROC_REF(on_target_anchor_moved))
	update_view()

/datum/secondary_map/render_entire_shuttle/proc/unset_target()
	if(!target)
		return
	UnregisterSignal(target, list(COMSIG_QDELETING, COMSIG_SHUTTLE_ANCHOR_MOVED))
	if(target.anchor)
		UnregisterSignal(target.anchor, COMSIG_SHUTTLE_ANCHOR_MOVED)
	target = null
	update_view()

/datum/secondary_map/render_entire_shuttle/proc/set_border_radius(new_radius)
	border_radius = new_radius
	update_view()
