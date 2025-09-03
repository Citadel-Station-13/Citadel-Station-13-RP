//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_REAL(event_logger, /datum/world_event_logger) = new /datum/world_event_logger/json_flatfile

/**
 * event logging API
 *
 * * API for dumping mass data, where normal logs should be human readable.
 * * When recording entities, record references, not names. This is for future viewers that can
 *   potentially cross-reference said entities.
 * * Encode location data as real world coordinates, not map IDs. This is both for speed and is
 *   due to the fact that map IDs will be established in trace log metadata separately.
 */
/datum/world_event_logger

/datum/world_event_logger/proc/setup_logger(log_directory)

/datum/world_event_logger/proc/shutdown_logger()

/datum/world_event_logger/proc/log__gun_firing_cycle(obj/item/gun, datum/gun_firing_cycle/cycle)
	// DEFINE THIS IN YOUR LOGGER SUBTYPE
	CRASH("event logger does not implement base call")

/datum/world_event_logger/proc/log__rigsuit_hotbind(obj/item/rig/rig, datum/event_args/actor/actor, action, list/params)
	log__rigsuit_raw(rig, actor, "hotbind", list("action" = action, "params" = params))

/datum/world_event_logger/proc/log__rigsuit_click(obj/item/rig/rig, datum/event_args/actor/clickchain/clickchain)
	// don't log rest of clickchain, clickchain has its own logging proc that
	// captures everything else, we only care about the rig-injected data
	log__rigsuit_raw(rig, clickchain, "clickchain", list("data" = clickchain.data?[ACTOR_DATA_RIGSUIT_CLICK_LOG]))

/datum/world_event_logger/proc/log__rigsuit_raw(obj/item/rig/rig, datum/event_args/actor/actor, action, list/data)
	// DEFINE THIS IN YOUR LOGGER SUBTYPE
	CRASH("event logger does not implement base call")

// todo: log__clickchain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
// todo: tool step logging
// todo: throw logging
// todo: inventory logging
