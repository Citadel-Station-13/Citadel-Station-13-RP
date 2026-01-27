//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Contains all active bans for a player for quick lookup.
 * * Will only contain one ban per relevant thing; e.g. if someone's somehow triple-jobbanned
 *   from captain, it'll only have one.
 */
/datum/player_ban_cache
	var/total_bans
	var/datum/player_ban/is_server_banned
	/// id = entry
	var/alist/datum/player_ban/currently_banned_role_ids
	/// class = entry
	var/alist/datum/player_ban/currently_banned_role_classes
