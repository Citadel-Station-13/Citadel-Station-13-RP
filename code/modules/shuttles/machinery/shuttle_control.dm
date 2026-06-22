//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/machinery/computer/shuttle_control
	name = "shuttle controller"
	desc = "A control interface for a shuttle."
	#warn icon

	circuit = /obj/item/circuitboard/shuttle_control

	/// bound shuttle ID; null to bind to current location instead
	///
	/// for game design purposes of not having magic remote-control
	/// consoles, it's a good idea in general to make us indestructible
	/// if this is hard-set.
	var/always_bind_shuttle_id
	/// are we a hardcoded console?
	var/hardcoded = FALSE
	/// our current shuttle instance
	var/datum/shuttle/shuttle

/obj/machinery/computer/shuttle_control/Initialize(mapload)
	. = ..()
	if(always_bind_shuttle_id)
		hardcoded = TRUE
		// if it's already set, we shouldn't be movable.
		integrity_flags |= INTEGRITY_INDESTRUCTIBLE
	autodetect_shuttle()

/obj/machinery/computer/shuttle_control/proc/autodetect_shuttle()
	if(always_bind_shuttle_id)
		shuttle = SSshuttle.shuttle_registry[always_bind_shuttle_id]
		return
	var/area/shuttle/shuttle_area = loc?.loc
	if(istype(shuttle_area))
		shuttle = shuttle_area.shuttle
	else
		shuttle = null

/obj/machinery/computer/shuttle_control/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	autodetect_shuttle()

/obj/machinery/computer/shuttle_control/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("dock")
		if("undock")
		if("manual")
		if("destination")
		if("launch")
		if("force")
			var/dangerous = params["dangerous"]
		if("abort")
		if("removeCode")
			var/code = params["code"]
		if("addCode")
			var/code = params["code"]
		#warn impl

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	// TODO: instead of doing this on click, can we redetect when the area under us changes? that's how shuttles are made
	if(!shuttle)
		autodetect_shuttle()

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
