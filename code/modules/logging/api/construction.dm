//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/log_userless_construction(atom/target, message)
	log_game("CONSTRUCTION: userless --> [target] ([target.coord_log_string()]) - [message]")

/**
 * Actor being missing is handled. Target and message are mandatory.
 */
/proc/log_actor_construction(atom/target, datum/event_args/actor/actor, message)
	log_game("CONSTRUCTION: [actor? actor.actor_log_string() : "no-actor"] --> [target] ([target.coord_log_string()]) - [message]")
