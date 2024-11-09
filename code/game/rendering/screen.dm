//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/atom/movable/screen
	appearance_flags = PIXEL_SCALE | NO_CLIENT_COLOR
	atom_colouration_system = FALSE
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.
	var/datum/hud/hud_legacy = null // A reference to the owner HUD, if any.

/**
 * called to resync to a hud_style datum
 */
/atom/movable/screen/proc/sync_to_preferences(datum/hud_preferences/preference_set)
	return

/atom/movable/screen/Destroy()
	master = null
	return ..()

//* Default Click Handling *//

/atom/movable/screen/Click(location, control, params)
	if(!check_allowed(usr))
		return
	on_click(usr, params2list(params))

/atom/movable/screen/DblClick(location, control, params)
	if(!check_allowed(usr))
		return
	on_doubleclick(usr, params2list(params))

/atom/movable/screen/proc/on_click(mob/user, list/params)
	return

/atom/movable/screen/proc/on_doubleclick(mob/user, list/params)
	return

/atom/movable/screen/proc/check_allowed(mob/user)
	if(hud_legacy?.mymob && user != hud_legacy.mymob)
		return FALSE
	return TRUE
