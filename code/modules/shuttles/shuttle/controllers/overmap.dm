//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * overmap shuttle controller
 */
/datum/shuttle_controller/overmap
	tgui_module = "TGUIShuttleOvermap"

	/// our overmap object
	var/obj/overmap/entity/entity
	#warn hook, somehow

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
	ASSERT(istype(entity, /obj/overmap/entity/visitable/ship/landable))
	var/obj/overmap/entity/visitable/ship/landable/casted = entity
	#warn impl
	return TRUE

#warn impl all
