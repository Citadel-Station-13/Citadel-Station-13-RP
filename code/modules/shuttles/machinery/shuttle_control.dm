//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/obj/machinery/computer/shuttle_control
	name = "shuttle controller"
	desc = "A control interface for a shuttle."
	#warn icon

	/// bound shuttle ID; null to autoinit on our shuttle
	///
	/// for game design purposes of not having magic remote-control
	/// consoles, it's a good idea in general to make us indestructible
	/// if this is hard-set.
	var/shuttle_id
	/// are we a hardcoded console?
	var/hardcoded = FALSE
	/// our current shuttle instance
	var/datum/shuttle/shuttle

/obj/machinery/computer/shuttle_control/Initialize(mapload)
	. = ..()
	if(isnull(shuttle_id))
		autodetect_shuttle()
	else
		hardcoded = TRUE
		// if it's already set, we shouldn't be movable.
		integrity_flags |= INTEGRITY_INDESTRUCTIBLE

/obj/machinery/computer/shuttle_control/proc/autodetect_shuttle()
	var/area/shuttle/shuttle_area = loc?.loc
	if(istype(shuttle_area))
		shuttle = shuttle_area.shuttle
		shuttle_id = shuttle_area.shuttle.id

/obj/machinery/computer/shuttle_control/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(hardcoded)
		return
	var/area/shuttle/shuttle_area = loc?.loc
	var/changed = FALSE
	if(shuttle_area?.shuttle?.id != shuttle_id)
		shuttle_id = shuttle_area?.shuttle?.id
		shuttle = shuttle_area?.shuttle
		changed = TRUE
	// todo: if changed, update everything, don't just close
	if(!shuttle || changed)
		SStgui.close_uis(src)

/obj/machinery/computer/shuttle_control/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		#warn impl

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShuttleConsole")
		ui.register_module(shuttle.controller, "shuttle")
		ui.open()

/obj/machinery/computer/shuttle_control/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/computer/shuttle_control/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

#warn impl all

/**
 * hardcoded shuttle control consoles
 * these should not be deconstructible as we don't want
 * players to get ahold of remote-control shuttle consoles without wanting them
 * to do so.
 */
/obj/machinery/computer/shuttle_control/hardcoded
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
