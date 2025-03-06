//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base type of gun attachments
 *
 * Invariants:
 *
 * * while attached, our loc is **always** the gun we're attached to
 * * on_attach() will only ever be called once during one logical attach/detach cycle
 * * on_detach() will only ever be called once during one logical attach/detach cycle
 * * on_attach() will be properly called if we are created as part of a gun's init
 * * on_detach() will be properly called if we, or the gun, are destroyed
 */
/obj/item/gun_attachment
	//* System *//

	/// The gun we're attached to
	var/obj/item/gun/attached
	/// Can detach
	var/can_detach = TRUE

	//* Actions *//

	/// cached action descriptors
	///
	/// this can be:
	/// * a /datum/action instance
	/// * a /datum/action typepath
	/// * a list of /datum/action instancse
	/// * a list of /datum/action typepaths
	///
	/// typepaths get instanced on us entering inventory
	var/attachment_actions
	/// if [attachment_actions] is not set, and this is, we make a single action rendering ourselves
	/// and set its name to this
	var/attachment_action_name
	/// if [attachment_actions] is not set, and [action_name] is set, this is the mobility flags
	/// the action will check for
	var/attachment_action_mobility_flags = MOBILITY_CAN_HOLD | MOBILITY_CAN_USE

	/// grant item actions to gun wielder
	var/relay_item_actions = TRUE

	//* Alignment *//

	/// alignment x
	///
	/// * what this is depends on our [attachment_slot]
	var/align_x = 0
	/// alignment y
	///
	/// * what this is depends on our [attachment_slot]
	var/align_y = 0

	//* Rendering *//

	/// the icon-state in our icon to use for the gun overlay
	///
	/// * defaults to "[icon_state]-gun" otherwise
	var/gun_state
	/// the current applied overlay
	///
	/// * only update_gun_overlay() can modify this, and you shouldn't be using this for anything in a non-read-only
	///   context. no, you are not special; there's no exceptions
	var/list/appearance/gun_applied_overlay
	/// * disable for no overlay
	var/render_on_gun = TRUE

	//* Slots *//

	/// attachment slot enum
	var/attachment_slot
	/// attachment type conflict; if set, we cannot be attached if another of this type
	/// is attached.
	var/attachment_type = NONE

/obj/item/gun_attachment/Destroy()
	if(attached)
		attached.uninstall_attachment(src, deleting = TRUE)
	return ..()

/obj/item/gun_attachment/update_icon()
	// update_icon_state can change state
	var/old_state = icon_state
	. = ..()
	if(icon_state != old_state)
		update_gun_overlay()

/**
 * Checks if we fit on a gun.
 *
 * * gun already checks for [attachment_slot]
 * * gun already checks for [attachment_type]
 */
/obj/item/gun_attachment/proc/fits_on_gun(obj/item/gun/gun, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * called on attach (including at init)
 *
 * * `attached` is set by this point
 * * [attachment_actions] is handled gun-side
 * * overlay addition is handled on the gun side, but can be handled on our side too
 */
/obj/item/gun_attachment/proc/on_attach(obj/item/gun/gun)
	SHOULD_CALL_PARENT(TRUE)

/**
 * called on detach (including during destroy)
 *
 * * `attached` is not cleared yet, at this point
 * * [attachment_actions] is handled gun-side
 * * overlay removal is handled on the gun side
 */
/obj/item/gun_attachment/proc/on_detach(obj/item/gun/gun)
	SHOULD_CALL_PARENT(TRUE)

/**
 * sets our gun state
 *
 * * setting it to null is a good way to force an update if our icon state is being used
 */
/obj/item/gun_attachment/proc/set_gun_state(new_state)
	gun_state = new_state
	update_gun_overlay()

/**
 * get the overlay to apply to our gun
 */
/obj/item/gun_attachment/proc/get_gun_overlay()
	if(!attached)
		return null
	var/mutable_appearance/applying = new /mutable_appearance
	applying.icon = icon
	applying.icon_state = gun_state || "[icon_state]-gun"
	applying.layer = FLOAT_LAYER
	applying.plane = FLOAT_PLANE
	attached.align_attachment_overlay(src, applying)
	return applying

/**
 * reapplies gun overlay
 */
/obj/item/gun_attachment/proc/update_gun_overlay()
	if(!attached)
		return
	remove_gun_overlay()
	if(!render_on_gun)
		return
	var/appearance/applying = get_gun_overlay()
	if(!applying)
		return
	// no stuck overlays now
	ASSERT(!gun_applied_overlay)
	attached.add_overlay(applying, TRUE)
	gun_applied_overlay = applying

/**
 * removes gun overlay
 */
/obj/item/gun_attachment/proc/remove_gun_overlay()
	if(!attached)
		return
	if(!gun_applied_overlay)
		return
	attached.cut_overlay(gun_applied_overlay, TRUE)
	gun_applied_overlay = null

/**
 * This is a very special proc.
 *
 * This proc allows you to 'redirect' the actual item uninstalled to another item,
 * useful for 'virtual' attachments made for things like maglights.
 *
 * The item returned will be what is dropped / put into the user's hands.
 *
 * If you return something else, you generally want to qdel(src).
 *
 * * This proc will **not** be called if we're being deleted.
 *
 * @params
 * * move_to_temporarily - move something to here if it's being dropped, or it'll be deleted by root of /movable/Destroy()
 *                         due to being in contents.
 */
/obj/item/gun_attachment/proc/uninstall_product_transform(atom/move_to_temporarily)
	return src

//* Actions *//

/**
 * instructs all our action buttons to re-render
 */
/obj/item/gun_attachment/update_action_buttons()
	..()
	if(islist(attachment_actions))
		for(var/datum/action/action in attachment_actions)
			action.update_buttons()
	else if(istype(attachment_actions, /datum/action))
		var/datum/action/action = attachment_actions
		action.update_buttons()

/**
 * ensures our [attachment_actions] variable is set to:
 *
 * * null
 * * a list of actions
 * * an action instance
 */
/obj/item/gun_attachment/proc/ensure_attachment_actions_loaded()
	if(attachment_actions)
		if(islist(attachment_actions))
			var/requires_init = FALSE
			for(var/i in 1 to length(attachment_actions))
				if(ispath(attachment_actions[i]))
					requires_init = TRUE
					break
			if(requires_init)
				set_attachment_actions_to(attachment_actions)
		else if(ispath(attachment_actions))
			set_attachment_actions_to(attachment_actions)
	else if(attachment_action_name)
		var/datum/action/attachment_action/created = new(src)
		created.name = attachment_action_name
		created.check_mobility_flags = attachment_action_mobility_flags
		set_attachment_actions_to(created)

/**
 * setter for [attachment_actions]
 *
 * accepts:
 *
 * * an instance of /datum/action
 * * a typepath of /datum/action
 * * a list of /datum/action instances and typepaths
 * * null
 */
/obj/item/gun_attachment/proc/set_attachment_actions_to(descriptor)
	var/mob/worn_mob = attached.get_worn_mob()

	if(worn_mob)
		unregister_attachment_actions(worn_mob)

	if(ispath(descriptor, /datum/action))
		descriptor = new descriptor(src)
	else if(islist(descriptor))
		var/list/transforming = descriptor:Copy()
		for(var/i in 1 to length(transforming))
			if(ispath(transforming[i], /datum/action))
				var/path = transforming[i]
				transforming[i] = new path(src)
		descriptor = transforming
	else
		attachment_actions = descriptor

	if(worn_mob)
		register_attachment_actions(worn_mob)

/**
 * handles action granting
 */
/obj/item/gun_attachment/proc/register_attachment_actions(mob/user)
	ensure_attachment_actions_loaded()
	if(islist(attachment_actions))
		for(var/datum/action/action in attachment_actions)
			action.grant(user.inventory.actions)
	else if(istype(attachment_actions, /datum/action))
		var/datum/action/action = attachment_actions
		action.grant(user.inventory.actions)

/**
 * handles action revoking
 */
/obj/item/gun_attachment/proc/unregister_attachment_actions(mob/user)
	if(islist(attachment_actions))
		for(var/datum/action/action in attachment_actions)
			action.revoke(user.inventory.actions)
	else if(istype(attachment_actions, /datum/action))
		var/datum/action/action = attachment_actions
		action.revoke(user.inventory.actions)
