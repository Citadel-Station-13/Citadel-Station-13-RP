//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * gun attachments
 *
 * todo: onmob rendering support
 */
/obj/item/gun_attachment
	name = "An attachment for a gun"
	desc = "Huh?"
	#warn sprite

	/// attachment slot this goes into
	var/attachment_slot
	/// override icon for on-gun overlay, otherwise uses icon
	var/gun_icon
	/// override icon state for on-gun overlay, otherwise uses icon_state
	var/gun_icon_state

	/// gun we're attached to
	var/obj/item/gun/attached
	/// the appearance we're currently using for the gun we're attached to
	//  todo: recycling/optimization?
	var/mutable_appearance/attached_appearance_cached

#warn impl all

/obj/item/gun_attachment/Destroy()
	attached?.detach_attachment(src, FALSE)
	return ..()

/**
 * Actor can be null.
 */
/obj/item/gun_attachment/proc/on_attach(obj/item/gun/gun, datum/event_args/actor/actor)

/**
 * Actor can be null.
 */
/obj/item/gun_attachment/proc/on_detach(obj/item/gun/gun, datum/event_args/actor/actor)
