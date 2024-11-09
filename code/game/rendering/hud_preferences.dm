//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A set of preferences for how to render the game's HUDs.
 */
/datum/hud_preferences
	/// desired hud style - set at base of sync_client
	var/datum/hud_style/hud_style
	/// desired hud color - set at base of sync_client
	var/hud_color
	/// desired hud alpha - set at base of sync_client
	var/hud_alpha

/**
 * todo: remove
 */
/client/proc/legacy_get_hud_preferences()
	var/datum/hud_preferences/creating = new
	creating.hud_style = preferences.get_entry(/datum/game_preference_entry/dropdown/hud_style)
	creating.hud_color = preferences.get_entry(/datum/game_preference_entry/simple_color/hud_color)
	creating.hud_alpha = preferences.get_entry(/datum/game_preference_entry/number/hud_alpha)
