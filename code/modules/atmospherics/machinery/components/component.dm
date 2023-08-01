//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/machinery/atmospherics/component
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN | INTERACT_MACHINE_OPEN_SILICON | INTERACT_MACHINE_OFFLINE | INTERACT_MACHINE_OFFLINE_SILICON
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

	/// efficiency multiplier
	var/efficiency_multiplier = 1

	/// are we on?
	var/on = FALSE
	/// maximum power limit in watts
	var/power_maximum = 0
	/// power setting configured in watts
	var/power_setting
	/// current power usage in watts
	var/power_current = 0

	//! legacy below
	/// legacy power limit in watts
	var/power_rating = 7500

/obj/machinery/atmospherics/component/Initialize(mapload, newdir)
	. = ..()
	if(isnull(power_setting))
		power_setting = power_maximum
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

// todo: use a special state to handle multitool hijacking

// /obj/machinery/atmospherics/component/ui_state(mob/user, datum/tgui_module/module)
// 	return GLOB.default_state

/obj/machinery/atmospherics/component/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["powerRating"] = power_maximum
	.["controlFlags"] = atmos_component_ui_flags

/obj/machinery/atmospherics/component/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!tgui_interface)
		return
	.["on"] = on
	.["powerSetting"] = power_setting
	if(atmos_component_ui_flags & (ATMOS_COMPONENT_UI_SEE_POWER | ATMOS_COMPONENT_UI_SET_POWER))
		.["powerUsage"] = power_current

/obj/machinery/atmospherics/component/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(!tgui_interface)
		return
	switch(action)
		if("togglePower")
			if(!(atmos_component_ui_flags & ATMOS_COMPONENT_UI_TOGGLE_POWER))
				return TRUE
			set_on(!on)
			return TRUE
		if("setPowerDraw")
			if(!(atmos_component_ui_flags & ATMOS_COMPONENT_UI_SET_POWER))
				return TRUE
			var/watts = text2num(params["target"])
			set_power(watts)
			return TRUE

/obj/machinery/atmospherics/component/interact(mob/user)
	// todo: interact needs a refactor; doing it like this stops fingerprints from applying.
	if(!allowed(user))
		user.action_feedback(SPAN_WARNING("Access denied."), src)
		return FALSE
	if(!default_access_interface)
		return FALSE
	// todo: refactor silicon interaction
	if(interface_require_exposed && is_hidden_underfloor() && !issilicon(user))
		return FALSE
	return ..()

/obj/machinery/atmospherics/component/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!tgui_interface)
		return ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, tgui_interface)
		ui.open()

/obj/machinery/atmospherics/component/multitool_act(obj/item/I, mob/user, flags, hint)
	. = ..()
	if(.)
		return
	if(isnull(default_multitool_hijack))
		return FALSE
	if(hijack_require_exposed && is_hidden_underfloor())
		user.action_feedback(SPAN_WARNING("You can't reach the controls of [src] while it's covered by flooring."), src)
		return TRUE
	user.visible_action_feedback(
		target = src,
		hard_range = MESSAGE_RANGE_CONFIGURATION,
		visible_hard = SPAN_WARNING("[user] starts tinkering with [src] using their [I]!"),
	)
	if(!do_after(user, default_multitool_hijack, src, mobility_flags = MOBILITY_CAN_USE))
		return TRUE
	ui_interact(user)
	return TRUE
