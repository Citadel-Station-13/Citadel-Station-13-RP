//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Say Module
//! Contains all relevant core procs for displaying (transmitting) messages, visible or audible.

#warn impl all

/atom/proc/visible_action_dual(list/params, hard_range, soft_range, visible_hard, visible_soft, self, ident, ghosts)
	var/list/atom/movable/targets = saycode_query(max(hard_range, soft_range))
	#warn impl

/atom/proc/audible_action_dual(list/params, hard_range, soft_range, audible_hard, audible_soft, self, ident, ghosts)
	var/list/atom/movable/targets = saycode_query(max(hard_range, soft_range))
	#warn impl

/atom/proc/full_action_dual(list/params, hard_range, soft_range, visible_hard, audible_hard, visible_soft, audible_soft, visible_self, audible_self, face_ident, voice_identv)
	var/list/atom/movable/targets = saycode_query(max(hard_range, soft_range))
	#warn impl

/atom/proc/visible_action(message, range, list/params, list/exclude_cache, self, ident, ghosts)
	var/list/atom/movable/targets = saycode_query(range)
	for(var/atom/movable/AM as anything in targets)
		AM.see_action(message, message, name, ident, src, FALSE, list())

/atom/proc/audible_action(message, range, list/params, list/exclude_cache, self, ident, ghosts)
	var/list/atom/movable/targets = saycode_query(range)
	for(var/atom/movable/AM as anything in targets)
		AM.hear_say(message, message, name, ident, src, FALSE, list(), GLOB.audible_action_language, list())

/atom/proc/full_action(visible, audible, range, list/params, list/exclude_cache, visible_self, audible_self, face_ident, voice_ident, ghosts)
	var/list/atom/movable/targets = saycode_query(range)
	for(var/atom/movable/AM as anything in targets)
		if(!AM.see_action(visible, visible, name, face_ident, src, FALSE, list()))
			AM.hear_say(audible, audible, name, voice_ident, src, FALSE, list(), GLOB.audible_action_language, list())

/**
 * gets stuff that might be able to hear us
 */
/atom/proc/saycode_query(range, ghosts)
	if(isbelly(loc))
		var/obj/belly/B = loc
		return B.effective_emote_hearers()
	. = get_hearers_in_view(range, src)
	if(ghosts)
		. |= GLOB.observer_list

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
