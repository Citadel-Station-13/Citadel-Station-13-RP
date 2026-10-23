//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * initializes an escape pod to be used for the main map.
 */
/obj/shuttle_dock/main_station_escape_pod

/obj/shuttle_dock/main_station_escape_pod/init_shuttle(datum/shuttle/shuttle)
	. = ..()
	var/datum/shuttle_controller/escape_pod/controller = new
	shuttle.bind_controller(controller)
