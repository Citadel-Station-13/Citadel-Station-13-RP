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

	/// alignment x; this is to align the lower-left corner of the attachment
	/// to the lower-left of the gun's placement
	var/align_x = 0
	/// alignment y; this is to align the lower-left corner of the attachment
	/// to the lower-left of the gun's placement
	var/align_y = 0

	//* Rendering *//

	/// the icon-state in our icon to use for the gun overlay
	///
	/// * defaults to icon_state otherwise
	var/attachment_state

	//* Slots *//

	/// attachment slot enum
	var/attachment_slot
	/// attachment type conflict; if set, we cannot be attached if another of this type
	/// is attached.
	var/attachment_conflict_type = NONE

/obj/item/gun_attachment/Initialize(mapload)
	. = ..()

/obj/item/gun_attachment/Destroy()
	if()
	return ..()

/**
 * Checks if we fit on a gun.
 *
 * * gun already checks for [attachment_slot]
 * * gun already checks for [attachment_conflict_type]
 */
/obj/item/gun_attachment/proc/fits_on_gun(obj/item/gun/gun)
	return TRUE

/**
 * called on attach (including at init)
 *
 * * [attachment_actions] is handled gun-side
 */
/obj/item/gun_attachment/proc/on_attach(obj/item/gun/gun)
	return

/**
 * called on detach (including during destroy)
 *
 * * [attachment_actions] is handled gun-side
 */
/obj/item/gun_attachment/proc/on_detach(obj/item/gun/gun)
	return


#warn impl

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
				set_actions_to(attachment_actions)
		else if(ispath(attachment_actions))
			set_actions_to(attachment_actions)
	else if(attachment_action_name)
		var/datum/action/attachment_action/created = new(src)
		created.name = attachment_action_name
		created.check_mobility_flags = attachment_action_mobility_flags
		set_actions_to(created)

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
/obj/item/gun_attachment/proc/set_actions_to(descriptor)
	var/mob/worn_mob = worn_mob()

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
