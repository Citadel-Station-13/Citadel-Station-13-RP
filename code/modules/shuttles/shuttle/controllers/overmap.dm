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

/datum/shuttle_controller/overmap/

#warn impl all
