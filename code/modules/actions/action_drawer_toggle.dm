//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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

/atom/movable/screen/movable/action_drawer_toggle/Click()
	if(usr.client != drawer.client)
		return
	drawer.toggle_hiding_buttons()

/atom/movable/screen/movable/action_drawer_toggle/update_icon(updates)
	cut_overlays()
	add_overlay(image(icon, drawer.hiding_buttons? "show" : "hide"))
	return ..()
