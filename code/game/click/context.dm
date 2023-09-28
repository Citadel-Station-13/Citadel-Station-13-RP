//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * get context options
 *
 * key is a text string
 * value are tuples; use ATOM_CONTEXT_TUPLE to create.
 *
 * @return list(key = value)
 */
/atom/proc/context_query(datum/event_args/actor/e_args)
	. = list()
	SEND_SIGNAL(src, COMSIG_ATOM_CONTEXT_QUERY, ., e_args)

/**
 * act on a context option
 *
 * things in this should re-check validity / sanity!
 *
 * @return TRUE / FALSE; TRUE if handled.
 */
/atom/proc/context_act(datum/event_args/actor/e_args, key)
	if(SEND_SIGNAL(src, COMSIG_ATOM_CONTEXT_ACT, key, e_args) & RAISE_ATOM_CONTEXT_ACT_HANDLED)
		return TRUE
	return FALSE

/atom/proc/context_menu(datum/event_args/actor/e_args)
	// admin proccall support
	WRAP_MOB_TO_ACTOR_EVENT_ARGS(e_args)
	// todo: dynamically rebuild menu based on distance?
	var/client/receiving = e_args.initiator.client
	if(isnull(receiving))
		// well what the hell are we doing here?
		// automated functions should be using context_query and context_act directly
	#warn impl
