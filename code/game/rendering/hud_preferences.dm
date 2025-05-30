//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_DATUM_INIT(default_hud_preferences, /datum/hud_preferences, new /datum/hud_preferences/default)

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

/datum/hud_preferences/default
	hud_style = new /datum/hud_style/midnight // yes, this doesn't use the global cached variant. sue me.
	hud_color = "#ffffff"
	hud_alpha = 200

/**
 * todo: remove
 */
/client/proc/legacy_get_hud_preferences()
	var/datum/hud_preferences/creating = new
	creating.hud_style = legacy_find_hud_style_by_name(preferences.get_entry(/datum/game_preference_entry/dropdown/hud_style)) || GLOB.hud_styles[/datum/hud_style/midnight::id]
	creating.hud_color = preferences.get_entry(/datum/game_preference_entry/simple_color/hud_color)
	creating.hud_alpha = preferences.get_entry(/datum/game_preference_entry/number/hud_alpha)
	return creating
