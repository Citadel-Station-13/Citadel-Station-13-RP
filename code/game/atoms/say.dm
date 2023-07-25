//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Say Module
//! Contains all relevant core procs for displaying (transmitting) messages, visible or audible.

#warn impl all

/atom/proc/visible_action_dual(hard_range, soft_range, visible_hard, visible_soft, list/exclude_cache, visible_self)
	var/list/atom/movable/targets = saycode_query(max(hard_range, soft_range))
	#warn impl

/atom/proc/audible_action_dual(hard_range, soft_range, audible_hard, audible_soft, list/exclude_cache, audible_self)
	var/list/atom/movable/targets = saycode_query(max(hard_range, soft_range))
	#warn impl

/atom/proc/full_action_dual(hard_range, soft_range, visible_hard, audible_hard, visible_soft, audible_soft, list/exclude_cache, visible_self, audible_self)
	var/list/atom/movable/targets = saycode_query(max(hard_range, soft_range))
	#warn impl

/atom/proc/visible_action(range, message, list/exclude_cache, self)
	var/list/atom/movable/targets = saycode_query(range)
	for(var/atom/movable/AM as anything in targets)
		AM.see_action(message, message, name, null, src, FALSE)

/atom/proc/audible_action(range, message, list/exclude_cache, self)
	var/list/atom/movable/targets = saycode_query(range)
	for(var/atom/movable/AM as anything in targets)
		AM.hear_say(message, message, name, null, src, FALSE, GLOB.audible_action_language, list(), list())

/atom/proc/full_action(range, visible, audible, list/exclude_cache, self)
	var/list/atom/movable/targets = saycode_query(range)
	for(var/atom/movable/AM as anything in targets)
		if(!AM.see_action(visible, visible, name, null, src, FALSE))
			AM.hear_say(audible, audible, name, null, src, FALSE, GLOB.audible_action_language, list(), list())

/**
 * gets stuff that might be able to hear us
 */
/atom/proc/saycode_query(range)
	if(isbelly(loc))
		var/obj/belly/B = loc
		return B.effective_emote_hearers()
	return get_hearers_in_view(range, src)

/**
 * standard proc for "extending" a hear across a portal or similar
 */
/atom/proc/saycode_relay_hear(range, list/heard_args)
	// cheap loop guard
	if(heard_args[MOVABLE_HEAR_ARG_REMOTE])
		return
	var/list/atom/movable/targets = saycode_query(range)
	for(var/atom/movable/AM as anything in targets)
		AM.hear_say(arglist(heard_args))

/**
 * standard proc for "extending" a see across a portal" or similar
 */
/atom/proc/saycode_relay_see(range, list/saw_args)
	// cheap loop guard
	if(saw_args[MOVABLE_SEE_ARG_REMOTE])
		return
	var/list/atom/movable/targets = saycode_query(range)
	for(var/atom/movable/AM as anything in targets)
		AM.see_action(arglist(saw_args))
