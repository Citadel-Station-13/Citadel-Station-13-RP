//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * shuttles loaded here gets turned into an overmap shuttle
 */
/obj/shuttle_dock/overmap_start

/obj/shuttle_dock/overmap_start/init_shuttle(datum/shuttle/shuttle)
	. = ..()

	var/datum/shuttle_controller/overmap/controller = new()
	shuttle.bind_controller(controller)
