//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Links to research consoles.
 */
/obj/machinery/research_peripheral
	// TODO: NEW SPRITE PLEASE
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"

	/// linked console
	var/obj/machinery/computer/research_console/linked_console

	/// tgui interface route for peripheral
	var/tgui_route

// TODO: implement

/obj/machinery/research_peripheral/Destroy()
	unlink_console()
	return ..()

/obj/machinery/research_peripheral/proc/link_console(obj/machinery/computer/research_console/console)

/obj/machinery/research_peripheral/proc/unlink_console()

/obj/machinery/research_peripheral/proc/on_console_link(obj/machinery/computer/research_console/console)

/obj/machinery/research_peripheral/proc/on_console_unlink(obj/machinery/computer/research_console/console)

/obj/machinery/research_peripheral/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_peripheral/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/obj/machinery/research_peripheral/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
