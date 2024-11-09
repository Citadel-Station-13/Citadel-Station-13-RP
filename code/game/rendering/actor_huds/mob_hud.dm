//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * owned by one mob as the user, and one mob as the owner
 *
 * therefore, keep screen locs as widescreen/viewrange agnostic as possible.
 *
 * * mob_hud is **owned** by a mob, meaning it's that mob's viewpoint
 * * mob_hud is **consumed / used** by clients, including the owning mob's client, as clients render the HUD.
 * * "but this is so low level it's hard to use for remote control"; that's what later on /datum/remote_control is for!
 * * mob_hud does not track screens/images unlike perspective! these are mostly stateless as they're externally synchronized.
 */
#warn port this over to actor hud lmao
/datum/mob_hud
	/// mob we're for (aka rendering the state of)
	var/mob/owner
	/// users using us
	var/list/client/using

	//* hud config *//

	/// desired hud style - set at base of sync_client
	var/datum/hud_style/hud_style
	/// desired hud color - set at base of sync_client
	var/hud_color
	/// desired hud alpha - set at base of sync_client
	var/hud_alpha

/datum/mob_hud/New(mob/owner)
	src.owner = owner

/datum/mob_hud/proc/sync_client(client/C)
	if(!C)
		hud_style = GLOB.hud_styles[/datum/hud_style/midnight::id]
		hud_color = "#ffffff"
		hud_alpha = 255
		return
	var/requested = C.get_preference_entry(/datum/game_preference_entry/dropdown/hud_style)
	hud_style = GLOB.hud_styles[all_ui_style_ids[requested]]
	if(isnull(hud_style))
		stack_trace("failed to get style [requested]")
		hud_style = new /datum/hud_style/midnight
	hud_color = C.get_preference_entry(/datum/game_preference_entry/simple_color/hud_color)
	hud_alpha = C.get_preference_entry(/datum/game_preference_entry/number/hud_alpha)

/datum/mob_hud/proc/apply_client(client/C)
	C.screen += screens()
	C.screen += images()

/datum/mob_hud/proc/unapply_client(client/C)
	C.screen -= screens()
	C.images -= images()
