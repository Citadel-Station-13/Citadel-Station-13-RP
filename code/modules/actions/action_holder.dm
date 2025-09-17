//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * holds a set of actions
 */
/datum/action_holder
	/// actions that are in us
	///
	/// * this is a lazylist
	var/list/datum/action/actions
	/// all drawers using us
	var/list/datum/action_drawer/drawers

/datum/action_holder/Destroy()
	for(var/datum/action/action as anything in actions)
		remove_action(action)
	for(var/datum/action_drawer/drawer as anything in drawers)
		drawer.unregister_holder(src)
	return ..()

/**
 * adds an action to us
 */
/datum/action_holder/proc/add_action(datum/action/action)
	return action.grant(src)

/**
 * removse an action from us
 */
/datum/action_holder/proc/remove_action(datum/action/action)
	return action.revoke(src)

/**
 * called when an action is added
 */
/datum/action_holder/proc/on_action_add(datum/action/action)
	for(var/datum/action_drawer/drawer as anything in drawers)
		drawer.add_action(action, src)

/**
 * called when an action is removed
 */
/datum/action_holder/proc/on_action_remove(datum/action/action)
	for(var/datum/action_drawer/drawer as anything in drawers)
		drawer.remove_action(action, src)

/**
 * get an actor tuple based on an invoker
 */
/datum/action_holder/proc/get_actor_data(mob/invoker)
	return new /datum/event_args/actor(invoker)

/**
 * for mob actions
 */
/datum/action_holder/mob_actor
	var/mob/user

/datum/action_holder/mob_actor/New(mob/user)
	src.user = user
	..()

/datum/action_holder/mob_actor/Destroy()
	user = null
	return ..()

/datum/action_holder/mob_actor/get_actor_data(mob/invoker)
	return new /datum/event_args/actor(user, invoker)

/**
 * for client
 */
/datum/action_holder/client_actor

/datum/action_holder/client_actor/New(client/user)
	..()
