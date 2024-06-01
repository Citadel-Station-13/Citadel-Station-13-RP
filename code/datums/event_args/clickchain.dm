//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * used to hold data about a click (melee/ranged/other) action
 *
 * the click may be real or fake.
 */
/datum/event_args/actor/clickchain
	/// optional: a_intent
	var/intent
	/// optional: click params
	var/list/params
	/// optional: target atom
	var/atom/target

/datum/event_args/actor/clickchain/New(mob/performer, mob/initiator, atom/target, intent, list/params)
	..()
	src.target = target
	src.intent = isnull(intent)? performer.a_intent : intent
	src.params = isnull(params)? list() : params
