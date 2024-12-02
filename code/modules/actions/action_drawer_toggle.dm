//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

INITIALIZE_IMMEDIATE(/atom/movable/screen/movable/action_drawer_toggle)
/atom/movable/screen/movable/action_drawer_toggle
	name = "Show / Hide Buttons"
	icon = 'icons/screen/actions/actions.dmi'
	icon_state = "bg_default"

	/// owning drawer
	var/datum/action_drawer/drawer

/atom/movable/screen/movable/action_drawer_toggle/Initialize(mapload, datum/action_drawer/drawer)
	src.drawer = drawer
	return ..()

/atom/movable/screen/movable/action_drawer_toggle/request_position_reset()
	var/index
	if(drawer.hiding_buttons)
		index = 1
	else if(length(drawer.using_actions))
		index = length(drawer.using_actions) + 1
	else
		index = 1
	screen_loc = drawer.screen_loc_for_index(index)

/atom/movable/screen/movable/action_drawer_toggle/Click(location, control, params)
	if(usr.client != drawer.client)
		return
	var/list/decoded_params = params2list(params)
	if(ctrl_shift_click_reset_hook(decoded_params))
		return
	drawer.toggle_hiding_buttons()

/atom/movable/screen/movable/action_drawer_toggle/update_icon(updates)
	cut_overlays()
	add_overlay(image(icon, drawer.hiding_buttons? "show" : "hide"))
	return ..()
