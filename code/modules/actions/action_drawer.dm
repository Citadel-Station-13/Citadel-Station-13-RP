//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * the actual action handler at /client,
 * allocates buttons and renders and whatnot
 */
/datum/action_drawer
	/// our client
	var/client/client

	/// holders that we are currently reigstered to
	var/list/datum/action_holder/using_holders
	/// actions on us, associated to their screen button
	var/list/datum/action/using_actions
	/// action = extra instances; used for deduping efficiently
	var/list/datum/action/duped_actions

	/// hiding all action buttons?
	var/hiding_buttons = FALSE
	/// our hide button
	var/atom/movable/screen/movable/action_button/hide_toggle

/datum/action_drawer/New(client/C)
	src.client = C

/datum/action_drawer/Destroy()
	client = null
	#warn unregister holders
	using_holders = using_actions = duped_actions = null
	QDEL_NULL(hide_toggle)
	return ..()

/**
 * propagates an action being pushed up by a holder
 */
/datum/action_drawer/proc/add_action(datum/action/action)
	#warn impl

/**
 * propagates an action being removed from a holder
 */
/datum/action_drawer/proc/remove_action(datum/action/action)
	#warn impl

/**
 * toggles if we're hiding buttons
 */
/datum/action_drawer/proc/toggle_hiding_buttons()
	hiding_buttons = !hiding_buttons
	var/list/atom/mvoable/screen/movable/action_button/buttons = all_action_buttons()
	if(hiding_buttons)
		client.screen -= buttons
	else
		client.screen += buttons

/**
 * gets all action button screen objects
 */
/datum/action_drawer/proc/all_action_buttons()
	. = list()
	for(var/key as anything in using_actions)
		. += using_actions[key]

