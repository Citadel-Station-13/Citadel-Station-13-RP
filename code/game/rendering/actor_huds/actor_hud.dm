//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * actor huds are:
 *
 * * used by one (1) client
 * * bound to one (1) mob
 * * renders the state of that mob if needed
 * * renders the state of the client's intent / will otherwise
 */
/datum/actor_hud
	/// the mob we're bound to right now
	var/mob/bound

/datum/actor_hud/proc/bind_to_mob(mob/target)
	if(bound == target)
		return FALSE
	bound_actor = target
	return TRUE

#warn impl
