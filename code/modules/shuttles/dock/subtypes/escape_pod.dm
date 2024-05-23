//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * initializes an escape pod to be used for the main map.
 */
/obj/shuttle_dock/escape_pod

/obj/shuttle_dock/escape_pod/init_shuttle(datum/shuttle/shuttle)
	. = ..()
	var/datum/shuttle_controller/escape_pod/controller = new
	shuttle.bind_controller(controller)
