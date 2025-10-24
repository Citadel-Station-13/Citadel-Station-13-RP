//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * This does NOT RETURN CLIENTS for a reason! Clients can be destroyed at any time.
 * You must check for client validity on the mob when executing.
 *
 * @params
 * * include_shared - Include mobs not technically part of our ownership in the location.
 *                    As an example, this means everyone on a shuttle's level (or overmap entity),
 *                    rather than only on the shuttle.
 */
/obj/overmap/entity/proc/get_all_players_in_location(include_shared) as /list
	#warn impl
