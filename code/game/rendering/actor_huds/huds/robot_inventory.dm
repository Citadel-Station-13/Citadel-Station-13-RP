//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/actor_hud/robot_inventory
	/// owning inventory
	var/datum/robot_inventory/host

	/// is robot module inventory shown?
	var/tmp/drawer_toggled = FALSE
	/// robot drawer object, if any
	var/atom/movable/screen/actor_hud/robot_inventory/robot_drawer/drawer_button
	/// robot drawer backplate, if any
	var/atom/movable/screen/actor_hud/robot_inventory/robot_drawer_backplate/drawer_backplate

/datum/actor_hud/robot_inventory/on_mob_bound(mob/target)
	if(isrobot(target))
		var/mob/living/silicon/robot/casted = target
		if(casted.robot_inventory)
			bind_to_inventory(casted.robot_inventory)
	return ..()

/datum/actor_hud/robot_inventory/on_mob_unbound(mob/target)
	if(isrobot(target))
		var/mob/living/silicon/robot/casted = target
		if(casted.robot_inventory)
			unbind_from_inventory(casted.robot_inventory)
	return ..()

/datum/actor_hud/robot_inventory/proc/bind_to_inventory(datum/robot_inventory/robot_inventory)
	ASSERT(!host)
	host = robot_inventory
	LAZYADD(robot_inventory.huds_using, src)
	rebuild()

/datum/actor_hud/robot_inventory/proc/unbind_from_inventory(datum/robot_inventory/robot_inventory)
	ASSERT(host == robot_inventory)
	cleanup()
	LAZYREMOVE(robot_inventory.huds_using, src)
	host = null

/datum/actor_hud/robot_inventory/screens()
	. = ..()
	if(drawer_button)
		. += drawer_button
	if(drawer_backplate)
		. += drawer_backplate

/datum/actor_hud/robot_inventory/proc/cleanup()
	remove_screen(drawer_backplate)
	QDEL_NULL(drawer_backplate)
	remove_screen(drawer_button)
	QDEL_NULL(drawer_button)

/datum/actor_hud/robot_inventory/proc/rebuild()
	add_screen((drawer_button = new(null, src)))
	drawer_button.screen_loc = screen_loc_for_drawer_button()
	add_screen((drawer_backplate = new(null, src)))
	set_drawer_backplate_parameters()
	drawer_backplate.redraw()

/datum/actor_hud/robot_inventory/proc/screen_loc_for_drawer_button()
	// Always aligned to right side of hands, assuming a 3-wide hands
	// TODO: can we auto-align based on the hands HUD? we'd need to do cascading re-renders..
	return "CENTER:64,BOTTOM:5"

/datum/actor_hud/robot_inventory/proc/set_drawer_backplate_parameters()
	drawer_backplate.first_tile_screen_ax = "LEFT+"
	drawer_backplate.first_tile_screen_ay = "BOTTOM+"
	drawer_backplate.first_tile_screen_tx = STORAGE_UI_START_TILE_X
	drawer_backplate.first_tile_screen_ty = STORAGE_UI_START_TILE_Y
	drawer_backplate.first_tile_screen_px = STORAGE_UI_START_PIXEL_X
	drawer_backplate.first_tile_screen_py = STORAGE_UI_START_PIXEL_Y
	drawer_backplate.is_vertical = FALSE
	drawer_backplate.main_axis_max_size = 9
	drawer_backplate.main_axis_offset = 1
	drawer_backplate.cross_axis_offset = 1

/datum/actor_hud/robot_inventory/proc/all_screen_objects()
	RETURN_TYPE(/list)
	. = list()
	if(drawer_button)
		. += drawer_button
	if(drawer_backplate)
		. += drawer_backplate

/datum/actor_hud/robot_inventory/proc/toggle_drawer()
	drawer_toggled = !drawer_toggled
	if(drawer_toggled && !drawer_backplate)
		drawer_backplate = new
	drawer_backplate?.redraw()
