//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * owned by one mob as the user, and one mob as the owner
 *
 * therefore, keep screen locs as widescreen/viewrange agnostic as possible.
 */
/datum/mob_hud
	/// mob we're for (aka rendering the state of)
	var/mob/owner
	/// users using us
	var/list/mob/using
	/// desired hud style - set at base of sync_client
	var/datum/hud_style/style

/datum/mob_hud/proc/screens()
	return list()

/datum/mob_hud/proc/images()
	return list()

/datum/mob_hud/proc/sync_client(client/C)
	var/requested = C.prefs.UI_style
	style = GLOB.hud_styles[all_ui_style_ids[requested]]
	if(isnull(style))
		stack_trace("failed to get style [requested]")
		style = new /datum/hud_style/midnight
	#warn take alpha/etc into account

/datum/mob_hud/proc/apply_client(client/C)
	C.screen += screens()
	C.screen += images()

/datum/mob_hud/proc/remove_client(client/C)
	C.screen -= screens()
	C.images -= images()

#warn impl all
