//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun_attachment/harness
	abstract_type = /obj/item/gun_attachment/harness
	icon = 'icons/modules/projectiles/attachments/harness.dmi'

/obj/item/gun_attachment/harness/magnetic
	name = "magnetic harness"
	desc = "A fancy harness that will snap a gun back to an attachment point when it's dropped by its wearer."
	prototype_id = "attachment-magnetic-harness"
	icon_state = "magnetic"
	align_x = 15
	align_y = 16
	attachment_slot = GUN_ATTACHMENT_SLOT_RAIL

	/// active?
	var/active = FALSE
	/// activation sound
	//  todo: better sound
	var/activate_sound = 'sound/weapons/empty.ogg'
	/// deactivation sound
	//  todo: better sound
	var/deactivate_sound = 'sound/weapons/empty.ogg'

	attachment_action_name = "Engage Harness"

/obj/item/gun_attachment/harness/magnetic/on_attach(obj/item/gun/gun)
	..()
	RegisterSignal(gun, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(gun, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))

/obj/item/gun_attachment/harness/magnetic/on_detach(obj/item/gun/gun)
	..()
	UnregisterSignal(gun, list(
		COMSIG_ITEM_PICKUP,
		COMSIG_ITEM_DROPPED,
	))

/obj/item/gun_attachment/harness/magnetic/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	set_active(!active, actor)

/obj/item/gun_attachment/harness/magnetic/proc/on_drop(datum/source, mob/user, inv_op_flags, atom/new_loc)
	SIGNAL_HANDLER
	if(!active)
		return NONE
	if(inv_op_flags & (INV_OP_DELETING | INV_OP_SHOULD_NOT_INTERCEPT))
		return NONE
	// don't react if it was already yanked
	if(attached.loc != user)
		return NONE
	if(!snap_back_to_user(user))
		return NONE
	return COMPONENT_ITEM_DROPPED_RELOCATE | COMPONENT_ITEM_DROPPED_SUPPRESS_SOUND

/obj/item/gun_attachment/harness/magnetic/proc/on_pickup(datum/source, mob/user, inv_op_flags, atom/old_loc)
	SIGNAL_HANDLER
	if(active)
		return
	set_active(TRUE, no_message = TRUE)
	to_chat(user, SPAN_NOTICE("The [src] engages as you pick up \the [attached]."))

/obj/item/gun_attachment/harness/magnetic/proc/snap_back_to_user(mob/user)
	var/target_slot_phrase
	for(var/slot_id in list(
		/datum/inventory_slot/inventory/suit_storage,
		/datum/inventory_slot/inventory/back,
	))
		if(!user.equip_to_slot_if_possible(attached, slot_id, INV_OP_SILENT))
			continue
		var/datum/inventory_slot/slot = resolve_inventory_slot(slot_id)
		target_slot_phrase = slot.display_name
		. = TRUE
	if(!.)
		return
	attached.visible_message(
		SPAN_WARNING("[attached] snaps back to [user]'s [target_slot_phrase]!"),
		range = MESSAGE_RANGE_COMBAT_SILENCED,
	)

/obj/item/gun_attachment/harness/magnetic/proc/set_active(state, datum/event_args/actor/actor, no_sound, no_message)
	if(state == active)
		return
	active = state
	var/datum/action/potential_action = istype(attachment_actions, /datum/action) ? attachment_actions : null
	if(active)
		potential_action?.set_button_active(TRUE)
		if(!no_sound)
			playsound(src, activate_sound, 15, TRUE, -4)
		if(!no_message)
			actor?.chat_feedback(SPAN_NOTICE("You activate \the [src]."), target = attached)
	else
		potential_action?.set_button_active(FALSE)
		if(!no_sound)
			playsound(src, deactivate_sound, 15, TRUE, -4)
		if(!no_message)
			actor?.chat_feedback(SPAN_NOTICE("You deactivate \the [src]."), target = attached)
