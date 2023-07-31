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
	/// allow access normally
	var/default_access_interface = FALSE
	/// need tile pried to access or to be above tile
	var/interface_require_exposed = FALSE
	/// need tiled pried to access or to be above tile
	var/hijack_require_exposed = FALSE
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
	/// current power usage
	var/power_current = 0

/obj/machinery/atmospherics/component/Initialize(mapload, newdir)
	. = ..()
	if(isnull(power_setting))
		power_setting = power_rating
	set_on(on)

/obj/machinery/atmospherics/component/proc/set_power(watts)
	power_setting = watts

/obj/machinery/atmospherics/component/proc/set_on(enabled)
	on = enabled
	if(enabled)
		update_use_power(USE_POWER_IDLE)
	else
		update_use_power(USE_POWER_OFF)
	update_icon()

/obj/machinery/atmospherics/component/process(delta_time)
	power_current = 0
	// todo: don't need this after pipenet rework
	build_network()

/obj/machinery/atmospherics/component/ui_state(mob/user, datum/tgui_module/module)
	#warn hijack
	return GLOB.default_state

/obj/machinery/atmospherics/component/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["powerRating"] = power_rating
	.["controlFlags"] = atmos_component_ui_flags

/obj/machinery/atmospherics/component/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!tgui_interface)
		return
	.["on"] = on
	.["powerSetting"] = power_setting
	if(atmos_component_ui_flags & ATMOS_COMPONENT_UI_SEE_POWER)
		.["powerUsage"] = power_usage
	else
		.["powerUsage"] = 0

/obj/machinery/atmospherics/component/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(!tgui_interface)
		return
	switch(action)
		if("togglePower")
			if(!(atmos_component_ui_flags & ATMOS_COMPONENT_UI_TOGGLE_POWER))
				return FALSE
			set_on(!on)
			return TRUE
		if("setPowerDraw")
			if(!(atmos_component_ui_flags & ATMOS_COMPONENT_UI_SET_POWER))
				return FALSE
			var/watts = text2num(params["target"])
			set_power(watts)
			return TRUE

/obj/machinery/atmospherics/component/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!tgui_interface)
		return ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, tgui_interface)
		ui.open()

/obj/machinery/atmospherics/component/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	. = ..()
	#warn impl hijack probably with states

