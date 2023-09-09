//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! New mob logging file. Helpers for things like attack, construction, etc, will go in here. !//
//! Saycode explicitly not included.                                                          !//

// todo: flesh this file out

/**
 * Logs a construction action / step
 *
 * @params
 * * target - target
 * * message - the message
 */
/mob/proc/actor_construction_log(atom/target, message)
	add_construction_logs(src, target, message)

/proc/add_construction_logs(mob/actor, atom/target, message)
	log_game("LEGACY CONSTRUCTION: [actor] --> [target] ([COORD(target)]): [message]")
