//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * ferry shuttle dock
 *
 * initializes any shuttle placed here to be a ferry
 */
/obj/shuttle_dock/ferry_start
	/// away id; we'll automatically use our id for home
	var/ferry_away_id

/obj/shuttle_dock/ferry_start/init_shuttle(datum/shuttle/shuttle)
	. = ..()

	var/datum/shuttle_controller/ferry/controller = new(dock_id, ferry_away_id)
	shuttle.bind_controller(controller)
