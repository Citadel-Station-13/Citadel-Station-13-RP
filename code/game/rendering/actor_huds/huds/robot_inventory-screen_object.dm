//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Base type of robot inventory screen objects.
 */
/atom/movable/screen/actor_hud/robot_inventory
	name = "inventory"
	plane = HUD_PLANE
	layer = HUD_LAYER_INVENTORY
	var/is_drawer = FALSE

/atom/movable/screen/actor_hud/robot_inventory/on_click(mob/user, list/params)
	if(is_drawer)
		var/datum/actor_hud/robot_inventory/casted = hud
		var/obj/item/held = user.get_active_held_item()
		if(held && casted.host?.inv_is_registered(held))
			// will trigger the robot inventory grabbing the item
			// INV_OP_FORCE because ermmmm no setting robot modules as nodrop!!
			user.drop_item_to_ground(held, INV_OP_FORCE)

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
	icon = 'icons/screen/hud/robot/default.dmi'
	icon_state = "drawer"
	is_drawer = TRUE

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
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	is_drawer = TRUE

	/// * FALSE: main axis is X, cross axis is Y
	/// * TRUE: main axis is Y, cross axis is X
	var/is_vertical
	/// tile offset applied to main axis per iteration
	var/main_axis_offset
	/// max items in a 'row', basically
	var/main_axis_max_size
	/// tile offset applied to main axis per iteration
	var/cross_axis_offset
	/// alignment; this is something like 'NORTH' as string
	var/first_tile_screen_ax
	/// alignment; this is something like 'NORTH' as string
	var/first_tile_screen_ay
	/// tile; this is a number
	var/first_tile_screen_tx
	/// tile; this is a number
	var/first_tile_screen_ty
	/// pixel; this is a number
	var/first_tile_screen_px
	/// pixel; this is a number
	var/first_tile_screen_py

	var/list/atom/movable/render/robot_drawer_item_render/renderers

/atom/movable/screen/actor_hud/robot_inventory/robot_drawer_backplate/proc/redraw()
	var/datum/actor_hud/robot_inventory/casted = hud
	var/safety = 255
	if(casted.drawer_toggled)
		// draw
		// check if we actually need to rebuild renderers; this is needed if row count changes
		// TODO: optimize this
		var/requires_rebuild = TRUE
		if(requires_rebuild)
			LAZYINITLIST(renderers)
			var/MAO = 0 // main axis offset
			var/CAO = 0 // cross axis offset
			var/MAC = 0 // main axis count
			var/AMT = length(casted.host.provided_items)
			if(AMT > safety)
				AMT = safety
				stack_trace("why the hell does a cyborg have more than 255 items?")
			for(var/IDX in 1 to AMT)
				if(MAC > main_axis_max_size)
					CAO++
					MAO = 0
					MAC = 0
				// fetch or make a renderer
				var/atom/movable/render/robot_drawer_item_render/renderer
				if(IDX > length(renderers))
					renderer = new /atom/movable/render/robot_drawer_item_render(null, hud, src)
				else
					renderer = renderers[IDX]
				// set its pixel loc as needed
				// 0, 0 is ontop of us
				if(is_vertical)
					renderer.pixel_x = CAO * cross_axis_offset * WORLD_ICON_SIZE
					renderer.pixel_y = MAO * main_axis_offset * WORLD_ICON_SIZE
				else
					renderer.pixel_x = MAO * main_axis_offset * WORLD_ICON_SIZE
					renderer.pixel_y = CAO * cross_axis_offset * WORLD_ICON_SIZE
				++MAO
				++MAC

			var/x_r = first_tile_screen_tx > 0 ? "[first_tile_screen_tx]" : "-[first_tile_screen_tx]"
			var/y_r = first_tile_screen_ty > 0 ? "[first_tile_screen_ty]" : "-[first_tile_screen_ty]"
			screen_loc = "[first_tile_screen_ax][x_r]:[first_tile_screen_px],\
			[first_tile_screen_ay][y_r]:[first_tile_screen_py]"
		// apply items
		var/ridx = 1
		var/iidx = 1
		var/iidx_max = length(casted.host.provided_items)
		var/ridx_max = length(renderers)
		while(iidx < iidx_max && ridx < ridx_max)
			var/atom/movable/render/robot_drawer_item_render/renderer = renderers[ridx]
			++iidx
			var/obj/item/item = casted.host.provided_items[iidx]
			if(item.inv_slot_or_index)
				// active module, don't render
				continue
			if(renderer.masquarading_as != item)
				renderer.masquarade(item)
			++ridx
		for(ridx in ridx to ridx_max)
			var/atom/movable/render/robot_drawer_item_render/renderer = renderers[ridx]
			if(renderer.masquarading_as)
				renderer.reset()

		src.invisibility = INVISIBILITY_NONE
	else
		// undraw
		for(var/atom/movable/render/robot_drawer_item_render/renderer as anything in renderers)
			renderer.reset()
		src.invisibility = INVISIBILITY_ABSTRACT

/**
 * Item renderer
 */
/atom/movable/render/robot_drawer_item_render
	name = "drawer"
	icon = 'icons/screen/hud/styles/common/storage.dmi'
	icon_state = "block"
	mouse_opacity = MOUSE_OPACITY_ICON
	var/atom/movable/screen/actor_hud/robot_inventory/robot_drawer_backplate/backplate
	var/obj/item/masquarading_as

/atom/movable/render/robot_drawer_item_render/Initialize(
	mapload,
	datum/actor_hud/robot_inventory/hud,
	atom/movable/screen/actor_hud/robot_inventory/robot_drawer_backplate/backplate
)
	. = ..()
	src.backplate = backplate
	src.backplate.vis_contents += src
	src.backplate.renderers += src
	reset()

/atom/movable/render/robot_drawer_item_render/Destroy()
	reset()
	src.backplate.vis_contents -= src
	src.backplate.renderers -= src
	src.backplate = null
	return ..()

/atom/movable/render/robot_drawer_item_render/Click(location, control, params)
	masquarading_as?.Click(arglist(args))

/atom/movable/render/robot_drawer_item_render/proc/masquarade(obj/item/render_as)
	if(masquarading_as)
		reset()
	vis_contents += render_as
	masquarading_as = render_as
	alpha = initial(alpha)

/atom/movable/render/robot_drawer_item_render/proc/reset()
	vis_contents.len = 0
	masquarading_as = null
	alpha = 0
