//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * controller
 *
 * things coordinate via this
 *
 * machinery, controllers, and remotes should be bound to this
 */
/obj/machinery/teleporter_controller
	name = "teleporter mainframe"
	desc = "A powerful mainframe controlling teleporters. This thing performs the necessary numbers-crunching to shunt things through bluespace tunnels, as well as coordinate all the machinery required to do so."
	#warn sprite

	/// autolink receive id
	/// normal link checks are still done
	var/autolink_id
	/// linked pad
	/// only one pad allowed
	var/obj/machinery/teleporter/bluespace_pad/pad
	/// linked capacitors
	/// capacitor linking is optional
	var/list/obj/machinery/teleporter/bluespace_capacitor/capacitors
	/// linked projectors
	var/list/obj/machinery/teleporter/bluespace_projector/projectors
	/// linked scanners
	var/list/obj/machinery/teleporter/bluespace_scanner/scanners

	/// linked consoles
	var/list/obj/machinery/computer/teleporter
	/// linked remotes
	var/list/obj/item/bluespace_remote/remotes

	/// our UI module
	var/datum/tgui_module/teleporter_control/ui_controller

/obj/machinery/teleporter_controller/Destroy()
	unlink_everything()
	QDEL_NULL(ui_controller)
	return ..()

/obj/machinery/teleporter_controller/proc/unlink_everything()
	#warn impl

/obj/machinery/teleporter_controller/proc/request_ui_controller()
	if(isnull(ui_controller))
		ui_controller = new(src)
	return ui_controller
