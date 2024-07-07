//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/atom/movable/screen
	appearance_flags = PIXEL_SCALE | NO_CLIENT_COLOR
	atom_colouration_system = FALSE
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.
	var/datum/hud/hud = null // A reference to the owner HUD, if any.

/**
 * called to resync to a hud_style datum
 */
/atom/movable/screen/proc/sync_style(datum/hud_style/style, alpha, color)
	return

/atom/movable/screen/Destroy()
	master = null
	return ..()
