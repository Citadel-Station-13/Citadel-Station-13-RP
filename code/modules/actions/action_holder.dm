//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * holds a set of actions
 */
/datum/action_holder
	/// actions that are in us
	///
	/// * this is a lazylist
	var/list/datum/action/actions

/**
 * adds an action to us
 */
/datum/action_holder/proc/add_action(datum/action/action)
	return action.regex_this_grant(src)

/**
 * removse an action from us
 */
/datum/action_holder/proc/remove_action(datum/action/action)
	return action.revoke(src)

/**
 * called when an action is added
 */
/datum/action_holder/proc/on_action_add(datum/action/action)
	#warn impl

/**
 * called when an action is removed
 */
/datum/action_holder/proc/on_action_remove(datum/action/action)
	#warn impl
