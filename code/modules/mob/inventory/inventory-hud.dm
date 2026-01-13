//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Imprints our rendering behavior on an actor HUD
 */
/datum/inventory/proc/hud_alter(datum/actor_hud/inventory/hud)
	hud.inv_held_items_row_mode = held_items_row_mode
	hud.inv_held_items_suppress_buttons = held_items_suppress_buttons
	hud.inv_held_items_use_robot_icon = held_items_use_robot_icon

/**
 * Modifies HUD object after syncing to preferences
 */
/datum/inventory/proc/hud_object_post_sync(datum/actor_hud/inventory/hud, atom/movable/screen/actor_hud/object)
	return
