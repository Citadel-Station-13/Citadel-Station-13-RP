//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/machinery/atmospherics/component
	default_deconstruct = 4 SECONDS
	tool_deconstruct = TOOL_WRENCH
	default_unanchor = null
	tool_unanchor = null
	default_panel = null
	tool_panel = null

	/// allow multitool "hijacking" even if this is controlled by something else
	/// set to non-null for delay.
	var/default_multitool_hijack = null
	/// tgui interface ID - set to non-null to use new atmospherics UI system
	//  todo: convert all atmos machinery to new system
	var/tgui_interface
	/// allowed default ui controls
	var/atmos_component_ui_flags = NONE
	/// are we on?
	var/on = FALSE
	/// maximum power limit in watts
	var/power_rating = 0
	/// power setting configured in watts
	var/power_setting

/obj/machinery/atmospherics/component/Initialize(mapload, newdir)
	. = ..()
	if(isnull(power_setting))
		power_setting = power_rating

/obj/machinery/atmospherics/component/ui_status(mob/user)
	if(!tgui_interface)
		return ..()
	. = ..()

/obj/machinery/atmospherics/component/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!tgui_interface)
		return

/obj/machinery/atmospherics/component/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(!tgui_interface)
		return

/obj/machinery/atmospherics/component/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!tgui_interface)
		return

/obj/machinery/atmospherics/component/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!tgui_interface)
		return ..()

/obj/machinery/atmospherics/component/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	. = ..()


#warn impl all
