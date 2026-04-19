//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * overmap shuttle controller
 */
/datum/shuttle_controller/overmap
	tgui_module = "TGUIShuttleOvermap"

	/// our overmap object
	var/obj/overmap/entity/entity
	#warn hook, somehow

/datum/shuttle_controller/overmap/initialize(datum/shuttle/shuttle)
	. = ..()
	#warn we need to make the entity and initialize_controller on us;
	#warn we also need to make sure the entity is in the right place after we move to roundstart.
	#warn alternatively when we finish a translation we immediately move our entity as needed.
	create_entity()

/datum/shuttle_controller/overmap/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()


/datum/shuttle_controller/overmap/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/shuttle_controller/overmap/ui_act(action, list/params, datum/tgui/ui)
	. = ..()


/datum/shuttle_controller/overmap/push_ui_location()
	. = ..()

/datum/shuttle_controller/overmap/proc/transit_to_freeflight(
	transit_flags,
	source_traversal_flags,
	target_traversal_flags,
)
	var/datum/shuttle_transit_cycle/cycle = new
	cycle.set_lazy_target(
		CALLBACK(src, PROC_REF(resolve_freeflight_for_transit)),
		SHUTTLE_LAZY_TARGET_HINT_MOVE_TO_FREEFLIGHT,
	)
	cycle.set_transit_flags(transit_flags)
	cycle.set_source_traversal_flags(source_traversal_flags)
	cycle.set_target_traversal_flags(target_traversal_flags)
	return run_transit_cycle(cycle)

/datum/shuttle_controller/overmap/proc/resolve_freeflight_for_transit(datum/shuttle_transit_cycle/cycle)
	// so technically, we want to be composition based, but,
	// in reality, old code dictates we have to be one type
	ASSERT(istype(entity, /obj/overmap/entity/visitable/ship/landable))
	var/obj/overmap/entity/visitable/ship/landable/casted = entity
	return casted.resolve_freeflight_for_transit()

/datum/shuttle_controller/overmap/proc/create_entity()
	ASSERT(isnull(entity))

	// so technically, we want to be composition based, but,
	// in reality, old code dictates we have to be one type
	var/datum/overmap_location/shuttle/assembled_location = new(src)
	entity = new /obj/overmap/entity/visitable/ship/landable(null, assembled_location)

	shuttle.descriptor.imprint_on_entity(entity)

	var/atom/detected_location = detect_entity_location()

	// it's fine to not detect *any* location; shuttles in nullspace (transit) are actually valid!
	if(detected_location)
		if(isturf(detected_location))
			// on turf
			entity.forceMove(detected_location)
		else if(istype(detected_location, /obj/overmap/entity))
			// docked inside something
			entity.forceMove(detected_location)

/**
 * Attempt to detect where to emplace an entity on the overmap based on our current location.
 *
 * @return null, turf, or another overmap entity
 */
/datum/shuttle_controller/overmap/proc/detect_entity_location()
	#warn impl

#warn impl all

/datum/shuttle_controller/overmap/manual_landing_levels()
	. = ..()
	#warn impl nearby entities?
