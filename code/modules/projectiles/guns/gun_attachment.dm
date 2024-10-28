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
	/// the icon-state in our icon to use for the gun overlay
	///
	/// * defaults to icon_state otherwise
	var/attachment_state
	/// attachment slot enum
	var/attachment_slot
	/// attachment type conflict; if set, we cannot be attached if another of this type
	/// is attached.
	var/attachment_conflict_type = NONE

	/// alignment x; this is to align the lower-left corner of the attachment
	/// to the lower-left of the gun's placement
	var/align_x = 0
	/// alignment y; this is to align the lower-left corner of the attachment
	/// to the lower-left of the gun's placement
	var/align_y = 0

/obj/item/gun_attachment/Initialize(mapload)
	. = ..()

/obj/item/gun_attachment/Destroy()
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
 */
/obj/item/gun_attachment/proc/on_attach(obj/item/gun/gun)

/**
 * called on detach (including during destroy)
 */
/obj/item/gun_attachment/proc/on_detach(obj/item/gun/gun)


#warn impl
