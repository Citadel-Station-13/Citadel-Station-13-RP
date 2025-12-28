//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Base type of robot inventory screen objects.
 */
/atom/movable/screen/actor_hud/robot_inventory
	name = "inventory"
	plane = HUD_PLANE
	layer = HUD_LAYER_INVENTORY

#warn FUCK
/atom/movable/screen/actor_hud/robot_inventory/on_click(mob/user, list/params)
	var/obj/item/held = user.get_active_held_item()
	handle_inventory_click(user, held)

/atom/movable/screen/actor_hud/robot_inventory/sync_to_preferences(datum/hud_preferences/preference_set)
	sync_style(preference_set.hud_style, preference_set.hud_alpha, preference_set.hud_color)

/atom/movable/screen/actor_hud/robot_inventory/proc/sync_style(datum/hud_style/style, style_alpha, style_color)
	alpha = style_alpha
	color = style_color

/**
 * Button: 'open / close robot modules'
 *
 * * The icon for this gets replaced with the robot's module if we're on an actual robot.
 */
/atom/movable/screen/actor_hud/robot_inventory/robot_drawer
	name = "module drawer"
	icon = 'icons/screen/hud/robot/module-drawer.dmi'
	icon_state = "robot-drawer"

/atom/movable/screen/actor_hud/robot_inventory/robot_drawer/sync_style(datum/hud_style/style, style_alpha, style_color)
	..()
	icon = style.robot_icons

/atom/movable/screen/actor_hud/robot_inventory/robot_drawer/on_click(mob/user, list/params)
	// todo: remote control
	var/datum/actor_hud/robot_inventory/inventory_hud = hud
	inventory_hud.toggle_drawer()

/**
 * Backplate for robot modules inventory.
 */
/atom/movable/screen/actor_hud/robot_inventory/robot_drawer_backplate
	icon = 'icons/screen/hud/styles/common/storage.dmi'
	icon_state = "block"

	var/list/atom/movable/render/robot_drawer_item_render/renderers

/atom/movable/screen/actor_hud/robot_inventory/robot_drawer_backplate/proc/redraw()
	var/datum/actor_hud/robot_inventory/casted = hud
	if(casted.drawer_toggled)
		// draw
		#warn impl
	else
		// undraw
		QDEL_LIST_NULL(renderers)

/**
 * Item renderer
 */
/atom/movable/render/robot_drawer_item_render

/atom/movable/render/robot_drawer_item_render/Initialize(mapload, datum/actor_hud/robot_inventory/hud, obj/item/render_as)
	. = ..()
	masquarade(render_as)

/atom/movable/render/robot_drawer_item_render/proc/masquarade(obj/item/render_as)


#warn above
