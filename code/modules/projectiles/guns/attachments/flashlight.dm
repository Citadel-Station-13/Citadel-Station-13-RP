//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A gun-attached flashlight
 *
 * * [light_range] and [light_color] are set directly, as they don't determine
 *   if a light source is enabled.
 * * [light_power] is toggled when on/off.
 * * We will set our icon_state directly, not gun_state. Do not use gun_state with flashlights.
 */
/obj/item/gun_attachment/flashlight
	abstract_type = /obj/item/gun_attachment/flashlight
	icon = 'icons/modules/projectiles/attachments/flashlight.dmi'
	light_range = 4.75
	light_color = "#ffffff"
	light_power = 0

	attachment_action_name = "Toggle Light"
	attachment_type = GUN_ATTACHMENT_TYPE_FLASHLIGHT

	/// are we on?
	var/on = FALSE
	/// power when on
	var/light_power_on = 0.75
	/// activation sound
	//  todo: better sound
	var/on_sound = 'sound/weapons/empty.ogg'
	/// deactivation sound
	//  todo: better sound
	var/off_sound = 'sound/weapons/empty.ogg'

/obj/item/gun_attachment/flashlight/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	set_on(!on)

/obj/item/gun_attachment/flashlight/on_detach(obj/item/gun/gun)
	set_on(FALSE)
	..()

/obj/item/gun_attachment/flashlight/update_icon_state()
	icon_state = "[base_icon_state || initial(icon_state)][on ? "-on" : ""]"
	return ..()

/obj/item/gun_attachment/flashlight/proc/set_on(state, datum/event_args/actor/actor)
	if(on == state)
		return
	on = state
	update_icon()
	var/datum/action/potential_action = istype(attachment_actions, /datum/action) ? attachment_actions : null
	// todo: silent support?
	if(on)
		playsound(src, on_sound, 15, TRUE, -4)
		attached.set_light(light_range, light_power_on, light_color)
		potential_action?.set_button_active(TRUE)
	else
		playsound(src, off_sound, 15, TRUE, -4)
		attached.set_light(light_range, 0, light_color)
		potential_action?.set_button_active(FALSE)

// todo: make this directional at some point
/obj/item/gun_attachment/flashlight/rail
	name = "rail light"
	icon_state = "raillight"
	prototype_id = "ItemAttachmentRailLight"
	align_x = 19
	align_y = 17
	attachment_slot = GUN_ATTACHMENT_SLOT_RAIL

/obj/item/gun_attachment/flashlight/internal
	name = "internal flashlight"
	desc = "The gun's internal flashlight"
	icon_state = "maglight"
	align_x = 0
	align_y = 0
	can_detach = FALSE
	render_on_gun = FALSE
	attachment_slot = GUN_ATTACHMENT_SLOT_UNDERBARREL

// todo: make this directional at some point
/**
 * Actually a 'virtual' attachment. When uninstalled, will drop a maglight instead of itself.
 */
/obj/item/gun_attachment/flashlight/maglight
	name = "maglight"
	icon_state = "maglight"
	prototype_id = "ItemAttachmentMaglight"
	align_x = 11
	align_y = 3
	attachment_slot = GUN_ATTACHMENT_SLOT_SIDEBARREL
	/// the maglight that made us
	var/obj/item/flashlight/maglight/our_maglight

/obj/item/gun_attachment/flashlight/maglight/Destroy()
	QDEL_NULL(our_maglight)
	return ..()

/obj/item/gun_attachment/flashlight/maglight/uninstall_product_transform(atom/move_to_temporarily)
	if(our_maglight)
		. = our_maglight
		our_maglight.forceMove(move_to_temporarily)
		our_maglight = null
	else
		return new /obj/item/flashlight/maglight
	qdel(src)
