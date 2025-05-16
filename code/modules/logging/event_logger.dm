//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_REAL(event_logger, /datum/world_event_logger) = new /datum/world_event_logger/json_flatfile

/**
 * event logging API
 *
 * * API for dumping mass data, where normal logs should be human readable.
 * * When recording entities, record references, not names. This is for future viewers that can
 *   potentially cross-reference said entities.
 */
/datum/world_event_logger

/datum/world_event_logger/proc/setup_logger(log_directory)

/datum/world_event_logger/proc/shutdown_logger()

/datum/world_event_logger/proc/log__gun_firing_cycle(obj/item/gun, datum/gun_firing_cycle/cycle)

// todo: log__clickchain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
// todo: tool step logging
// todo: throw logging
// todo: inventory logging
