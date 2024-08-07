//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * web shuttle dock
 *
 * initializes any shuttle loaded here to be a web shuttle
 *
 * we'll use the web datum we're joined on via web_node_type to join the shuttle.
 */
/obj/shuttle_dock/web_start

/obj/shuttle_dock/web_start/init_shuttle(datum/shuttle/shuttle)
	. = ..()

	#warn impl init
	var/datum/shuttle_controller/web/controller = new()
	shuttle.bind_controller(controller)
