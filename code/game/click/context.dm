//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * get context options
 *
 * key is a text string
 * value are tuples of (name, image)
 *
 * @return list(key = list(name, image))
 */
/atom/proc/context_query(mob/user, distance)
	. = list()
	SEND_SIGNAL(src, COMSIG_ATOM_CONTEXT_QUERY, ., user, distance)

/**
 * act on a context option
 *
 * @return TRUE / FALSE; TRUE if handled.
 */
/atom/proc/context_act(mob/user, key)
	if(SEND_SIGNAL(src, COMSIG_ATOM_CONTEXT_ACT, key, user) & RAISE_ATOM_CONTEXT_ACT_HANDLED)
		return TRUE
	return FALSE

#warn hook all
