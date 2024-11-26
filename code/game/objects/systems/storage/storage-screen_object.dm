//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/atom/movable/screen/storage
	name = "storage"
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER | TILE_BOUND
	plane = HUD_PLANE
	layer = HUD_LAYER_STORAGE
	icon = 'icons/screen/hud/common/storage.dmi'

/atom/movable/screen/storage/closer
	name = "close"
	icon_state = "close"

/atom/movable/screen/storage/closer/Click()
	usr.active_storage?.hide(usr)

/atom/movable/screen/storage/item
	plane = HUD_ITEM_PLANE
	layer = HUD_ITEM_LAYER_BASE
	var/obj/item/item

/atom/movable/screen/storage/item/New(newloc, obj/item/from_item)
	item = from_item
	bind(from_item)
	return ..()

/atom/movable/screen/storage/item/Destroy()
	item = null
	return ..()

/atom/movable/screen/storage/item/MouseEntered(location, control, params)
	. = ..()
	layer = HUD_ITEM_LAYER_ACTIVE

/atom/movable/screen/storage/item/MouseExited(location, control, params)
	. = ..()
	layer = HUD_ITEM_LAYER_BASE

/atom/movable/screen/storage/item/proc/item_mouse_enter(mob/user)
	layer = HUD_ITEM_LAYER_ACTIVE

/atom/movable/screen/storage/item/proc/item_mouse_exit(mob/user)
	layer = HUD_ITEM_LAYER_BASE

/atom/movable/screen/storage/item/MouseDrop(atom/over_object, src_location, over_location, src_control, over_control, params)
	return item?.MouseDrop(arglist(args))

/atom/movable/screen/storage/item/Click(location, control, params)
	return item?.Click(arglist(args))

/atom/movable/screen/storage/item/DblClick(location, control, params)
	return item?.DblClick(arglist(args))

/atom/movable/screen/storage/item/proc/bind(obj/item/item)
	vis_contents += item
	name = item.name
	desc = item.desc
	RegisterSignal(item, COMSIG_ITEM_MOUSE_ENTERED, PROC_REF(item_mouse_enter))
	RegisterSignal(item, COMSIG_ITEM_MOUSE_EXITED, PROC_REF(item_mouse_exit))

/atom/movable/screen/storage/panel

/atom/movable/screen/storage/panel/Click()
	var/obj/item/held = usr.get_active_held_item()
	if(isnull(held))
		return
	usr.active_storage?.auto_handle_interacted_insertion(held, new /datum/event_args/actor(usr))

//* Slot *//

/atom/movable/screen/storage/item/slot
	mouse_opacity = MOUSE_OPACITY_OPAQUE

/atom/movable/screen/storage/panel/slot

/atom/movable/screen/storage/panel/slot/boxes
	icon_state = "block"

//* Volumetric *//

/atom/movable/screen/storage/item/volumetric

/**
 * we are centered.
 */
/atom/movable/screen/storage/item/volumetric/proc/set_pixel_width(width)
	overlays.len = 0
	var/center_thickness = (width - (VOLUMETRIC_STORAGE_BOX_BORDER_SIZE * 2))
	var/shift_from_center = -((WORLD_ICON_SIZE * 0.5) - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE) + (center_thickness * 0.5)
	var/image/left = image(icon, "stored_left", HUD_LAYER_STORAGE_ITEM_BOUNDING, null, -shift_from_center)
	left.plane = HUD_PLANE
	var/image/right = image(icon, "stored_right", HUD_LAYER_STORAGE_ITEM_BOUNDING, null, shift_from_center)
	right.plane = HUD_PLANE
	var/image/middle = image(icon, "stored_middle", HUD_LAYER_STORAGE_ITEM_BOUNDING)
	middle.plane = HUD_PLANE
	middle.transform = matrix(center_thickness / VOLUMETRIC_STORAGE_BOX_ICON_SIZE, 0, 0, 0, 1, 0)
	overlays = list(left, middle, right)

/atom/movable/screen/storage/panel/volumetric

/atom/movable/screen/storage/panel/volumetric/left
	icon_state = "storage_left"

/atom/movable/screen/storage/panel/volumetric/middle
	icon_state = "storage_middle"

/**
 * we are centered.
 */
/atom/movable/screen/storage/panel/volumetric/middle/proc/set_pixel_width(width)
	transform = matrix(width / VOLUMETRIC_STORAGE_BOX_ICON_SIZE, 0, 0, 0, 1, 0)

/atom/movable/screen/storage/panel/volumetric/right
	icon_state = "storage_right"
