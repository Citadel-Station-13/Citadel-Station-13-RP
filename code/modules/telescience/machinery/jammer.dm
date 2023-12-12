//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/bluespace_jammer/integrated

/obj/item/bluespace_jammer/integrated/draw_power(amount)
	#warn impl

/obj/item/bluespace_jammer/integrated/ui_host(mob/user, datum/tgui_module/module)
	return loc.ui_host(arglist(args))

#warn circuit

/obj/machinery/bluespace_jammer
	name = "bluespace jammer"
	desc = "A high power bluespace jammer that disrupts teleportation locking near its area of effect.`"

	default_deconstruct = TOOL_CROWBAR
	default_unanchor = TOOL_WRENCH
	default_panel = TOOL_SCREWDRIVER

	/// our integrated bluespace beacon
	var/obj/item/bluespace_jammer/integrated/beacon = /obj/item/bluespace_jammer/integrated

/obj/machinery/bluespace_jammer/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

#warn circuit

/obj/machinery/bluespace_jammer/trap
	name = "bluespace trap"
	desc = "A specialized jammer that curves any tunnels moving through its area of effect, causing items in transit to be pulled near it instead of their intended destination."
