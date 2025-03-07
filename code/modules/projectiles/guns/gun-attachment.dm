//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Check if we can attach an attachment
 */
/obj/item/gun/proc/can_install_attachment(obj/item/gun_attachment/attachment, datum/event_args/actor/actor, silent)
	if(!attachment.attachment_slot || !attachment_alignment?[attachment.attachment_slot])
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[attachment] won't fit anywhere on [src]!"),
				target = src,
			)
		return FALSE
	if(attachment.attachment_type & attachment_type_blacklist)
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[attachment] doesn't work with [src]!"),
				target = src,
			)
		return FALSE
	for(var/obj/item/gun_attachment/existing as anything in attachments)
		if(existing.attachment_slot == attachment.attachment_slot)
			if(!silent)
				actor?.chat_feedback(
					SPAN_WARNING("[src] already has [existing] installed on its [existing.attachment_slot]!"),
					target = src,
				)
			return FALSE
		if(existing.attachment_type & attachment.attachment_type)
			if(!silent)
				actor?.chat_feedback(
					SPAN_WARNING("[src]'s [existing] conflicts with [attachment]!"),
					target = src,
				)
			return FALSE
	if(!attachment.fits_on_gun(src, actor, silent))
		return FALSE
	return TRUE

/**
 * Called when a mob tries to uninstall an attachment
 */
/obj/item/gun/proc/user_install_attachment(obj/item/gun_attachment/attachment, datum/event_args/actor/actor)
	if(actor)
		if(actor.performer && actor.performer.is_in_inventory(attachment))
			if(!actor.performer.can_unequip(attachment, attachment.worn_slot))
				actor.chat_feedback(
					SPAN_WARNING("[attachment] is stuck to your hand!"),
					target = src,
				)
				return FALSE
	if(!install_attachment(attachment, actor))
		return FALSE
	// todo: better sound
	playsound(src, 'sound/weapons/empty.ogg', 25, TRUE, -3)
	return TRUE

/**
 * Installs an attachment
 *
 * * This moves the attachment into the gun if it isn't already.
 * * This does have default visible feedback for the installation.
 *
 * @return TRUE / FALSE on success / failure
 */
/obj/item/gun/proc/install_attachment(obj/item/gun_attachment/attachment, datum/event_args/actor/actor, silent)
	if(!can_install_attachment(attachment, actor, silent))
		return FALSE

	if(!silent)
		actor?.visible_feedback(
			target = src,
			visible = SPAN_NOTICE("[actor.performer] attaches [attachment] to [src]'s [attachment.attachment_slot]."),
			range = MESSAGE_RANGE_CONFIGURATION,
		)
	if(attachment.loc != src)
		attachment.forceMove(src)

	LAZYADD(attachments, attachment)
	attachment.attached = src
	attachment.on_attach(src)
	attachment.update_gun_overlay()
	on_attachment_install(attachment)
	var/mob/holding_mob = get_worn_mob()
	if(holding_mob)
		attachment.register_attachment_actions(holding_mob)
	return TRUE

/**
 * Called when a mob tries to uninstall an attachment
 */
/obj/item/gun/proc/user_uninstall_attachment(obj/item/gun_attachment/attachment, datum/event_args/actor/actor, put_in_hands)
	if(!attachment.can_detach)
		actor?.chat_feedback(
			SPAN_WARNING("[attachment] is not removable."),
			target = src,
		)
		return FALSE
	var/obj/item/uninstalled = uninstall_attachment(attachment, actor)
	if(put_in_hands && actor?.performer)
		actor.performer.put_in_hands_or_drop(uninstalled)
	else
		var/atom/where_to_drop = drop_location()
		ASSERT(where_to_drop)
		uninstalled.forceMove(where_to_drop)
	// todo: better sound
	playsound(src, 'sound/weapons/empty.ogg', 25, TRUE, -3)
	return TRUE

/**
 * Uninstalls an attachment
 *
 * * This does not move the attachment after uninstall; you have to do that.
 * * This does not have default visible feedback for the uninstallation / removal.
 *
 * @return the /obj/item uninstalled
 */
/obj/item/gun/proc/uninstall_attachment(obj/item/gun_attachment/attachment, datum/event_args/actor/actor, silent, deleting)
	ASSERT(attachment.attached == src)
	var/mob/holding_mob = get_worn_mob()
	if(holding_mob)
		attachment.unregister_attachment_actions(holding_mob)
	attachment.on_detach(src)
	attachment.remove_gun_overlay()
	attachment.attached = null
	on_attachment_uninstall(attachment)
	LAZYREMOVE(attachments, attachment)
	if(!silent)
		actor?.visible_feedback(
			target = src,
			visible = SPAN_NOTICE("[actor.performer] detaches [attachment] from [src]'s [attachment.attachment_slot]."),
			range = MESSAGE_RANGE_CONFIGURATION,
		)
	return deleting ? null : attachment.uninstall_product_transform(src)

/**
 * Align an attachment overlay.
 *
 * @return TRUE / FALSE on success / failure
 */
/obj/item/gun/proc/align_attachment_overlay(obj/item/gun_attachment/attachment, image/appearancelike)
	var/list/alignment = attachment_alignment?[attachment.attachment_slot]
	if(!alignment)
		return FALSE
	appearancelike.pixel_x = (alignment[1] - attachment.align_x)
	appearancelike.pixel_y = (alignment[2] - attachment.align_y)
	return TRUE

/**
 * Called exactly once when an attachment is installed
 *
 * * Called before the attachment's on_attach()
 */
/obj/item/gun/proc/on_attachment_install(obj/item/gun_attachment/attachment)
	PROTECTED_PROC(TRUE)

/**
 * Called exactly once when an attachment is uninstalled
 *
 * * Called after the attachment's on_detach()
 */
/obj/item/gun/proc/on_attachment_uninstall(obj/item/gun_attachment/attachment)
	PROTECTED_PROC(TRUE)
