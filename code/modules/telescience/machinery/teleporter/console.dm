//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn circuit
/obj/machinery/computer/teleporter
	name = "teleporter control console"
	desc = "Used to control a linked teleportation mainframe and its peripherals"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"

	/// linked controller
	var/obj/machinery/teleporter_controller/controller
	/// autolink controller id
	var/controller_autolink_id

/obj/machinery/computer/teleporter/Initialize()
	if(controller_autolink_id)
		var/buffer = GLOB.telescience_linkage_buffers[controller_autolink_id]
		if(istype(buffer, /obj/machinery/teleporter_controller))
			var/obj/machinery/teleporter_controller/controller = buffer
			controller.auto_link_console(src)
		else
			LAZYADD(GLOB.telescience_linkage_buffers[controller_autolink_id], src)
	return ..()

/obj/machinery/computer/teleporter/Destroy()
	unlink_controller()
	return ..()

/obj/machinery/computer/teleporter/proc/link_controller(obj/machinery/teleporter_controller/controller)
	src.controller?.unlink_console(src)
	controller?.link_console(src)

/obj/machinery/computer/teleporter/proc/unlink_controller()
	src.controller?.unlink_console(src)

/obj/machinery/computer/teleporter/proc/controller_linked(obj/machinery/teleporter_controller/controller)
	src.controller = controller

/obj/machinery/computer/teleporter/proc/controller_unlinked(obj/machinery/teleporter_controller/controller)
	src.controller = null
