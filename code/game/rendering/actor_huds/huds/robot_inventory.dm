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
	if(target.robot_inventory)
		bind_to_inventory(target.robot_inventory)
	return ..()

/datum/actor_hud/robot_inventory/proc/bind_to_inventory(datum/robot_inventory/robot_inventory)
	ASSERT(!host)
	host = inventory
	LAZYADD(inventory.huds_using, src)
	rebuild()

/datum/actor_hud/robot_inventory/screens()
	. = ..()
	if(drawer_button)
		. += drawer_button
	if(drawer_backplate)
		. += drawer_backplate

/datum/actor_hud/robot_inventory/proc/unbind_from_inventory(datum/robot_inventory/robot_inventory)
	ASSERT(host == inventory)
	cleanup()
	LAZYREMOVE(inventory.huds_using, src)
	host = null

/datum/actor_hud/robot_inventory/on_mob_unbound(mob/target)
	if(target.robot_inventory)
		unbind_from_inventory(target.robot_inventory)
	return ..()

/datum/actor_hud/robot_inventory/proc/cleanup()
	QDEL_NULL(drawer_backplate)
	QDEL_NULL(drawer_toggle)

/datum/actor_hud/robot_inventory/proc/rebuild()
	add_screen((drawer_toggle = new(null, src)))
	drawer_toggle = screen_loc_for_drawer_toggle()
	#warn backplage?

/datum/actor_hud/robot_inventory/proc/screen_loc_for_drawer_toggle()
	// Always aligned to right side of hands.
	#warn impl
	// var/col = ceil(number_of_hands / 2) + 1
	// return "CENTER[col == 0 ? "" : (col > 0 ? "+[col]" : "-[col]")]:16,BOTTOM+1:5"

/datum/actor_hud/robot_inventory/proc/all_screen_objects()
	RETURN_TYPE(/list)
	. = list()
	if(drawer_button)
		. += drawer_button
	if(drawer_backplate)
		. += drawer_backplate

/datum/actor_hud/robot_inventory/proc/toggle_robot_modules()
	robot_module_inventory_drawn = !robot_module_inventory_drawn
	if(robot_module_inventory_drawn)
		if(!robot_drawer_backplate)
			robot_drawer_backplate = new
		robot_drawer_backplate.redraw()
		robot_drawer_backplate.invisibility = INVISIBILITY_NONE
	else
		// this is important to dump out item refs!
		robot_drawer_backplate.redraw()
		robot_drawer_backplate.invisibility = INVISIBILITY_ABSTRACT
