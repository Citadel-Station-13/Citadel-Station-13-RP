//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * overmap shuttle controller
 */
/datum/shuttle_controller/overmap
	tgui_module = "TGUIShuttleOvermap"
	
	/// our overmap object
	var/obj/overmap/entity
	#warn hook, somehow

/datum/shuttle_controller/overmap/tgui_static_data()
	. = ..()

/datum/shuttle_controller/overmap/tgui_data()
	. = ..()


#warn impl all
