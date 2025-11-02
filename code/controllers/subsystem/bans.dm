//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Ban management subsystem.
 * * Can hook PreInit()
 * * Must function as long as DBCore is connected.
 */
SUBSYSTEM_DEF(bans)
	name = "Bans"
	subsystem_flags = SS_NO_FIRE | SS_NO_INIT

// Blank for now. This will be the new banning system eventually.

/**
 * * While the system supports IP/CID jobbans, it is up to the API user to know what is reasonable
 *   to match on. So basically, don't do that.
 *
 * @params
 * * match_player_id - match any ckey on a player id
 * * match_ckey - match this ckey
 * * match_ip - match this ip (leave null to not ban by IP)
 * * match_computer_id - match `computerid`
 * * duration - duration in minutes; 0 for permanent
 * * reason - ban reason plaintext
 * * type_class - BAN_TYPE_* define (internally currently "server", "role", "role_class")
 * * type_id - ID within context of `type_class`.
 *             "server": nothing
 *             "role": "station-janitor", "station-chief-engineer", "special-changeling", ...
 *             "role_class": "station", "traveller", "antagonist", ...
 * * admin_ckey - (optional) banning admin's ckey
 * * admin_ip - (optional) banning admin's ip
 * * admin_computer_id - (optional) banning admin's computerid
 */
// /datum/controller/subsystem/bans/proc/place_ban(match_player_id, match_ckey, match_ip, match_computer_id, duration, reason, type_class, type_id, admin_ckey, admin_ip, admin_computer_id)
// /datum/controller/subsystem/bans/proc/edit_ban(ban_id, edit_reason, set_reason, set_duration, admin_ckey, admin_ip, admin_computer_id)
// /datum/controller/subsystem/bans/proc/remove_ban(ban_id, remove_reason, admin_ckey, admin_ip, admin_computer_id)
// /datum/controller/subsystem/bans/proc/get_ban(ban_id) as /datum/player_ban

/**
 * Returns any currently active ban for given match criterion
 * * It is not well defined what ban is returned if there's more than one active.
 *
 * @params
 * * match_player_id - match any ban with given player ID
 * * match_ckey
 * * match_ip
 * * match_computer_id
 * * type_class - type class to check for
 * * type_id - type id to check for
 */
// /datum/controller/subsystem/bans/proc/match_ban(match_player_id, match_ckey, match_ip, match_computer_id, type, type_id) as /datum/player_ban

/**
 * Scan bans to get a cache entry for a player.
 */
// /datum/controller/subsystem/bans/proc/scan_bans(match_player_id, match_ckey, match_ip, match_computer_id) as /datum/player_ban_cache

/**
 * Get all bans for a player. Paginated.
 */
// /datum/controller/subsystem/bans/proc/query_bans(match_player_id, match_ckey, match_ip, match_computer_id, active_only = FALSE, page = 1, per_page = 20) as /list
