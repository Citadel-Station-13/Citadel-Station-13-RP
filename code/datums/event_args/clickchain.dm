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
	/// hand index, if any
	var/hand_index
	/// with item, if any
	var/obj/item/using
	/// optional: target atom
	var/atom/target
	#warn deal with hand index lol

/datum/event_args/actor/clickchain/New(mob/performer, mob/initiator, atom/target, intent, list/params)
	..()
	src.target = target
	src.intent = isnull(intent)? performer.a_intent : intent
	src.params = isnull(params)? list() : params

/datum/event_args/actor/clickchain/clone()
	return new /datum/event_args/actor/clickchain(performer, initiator, target, intent, params)
