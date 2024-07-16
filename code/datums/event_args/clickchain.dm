/**
 * used to hold data about a click (melee/ranged/other) action
 *
 * the click may be real or fake.
 */
/datum/event_args/actor/clickchain
	/// optional: attack intent
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

/datum/event_args/actor/clickchain/New(mob/performer, mob/initiator, atom/target, list/params, intent)
	..()
	src.target = target
	src.params = params || list()
	src.intent = intent

/datum/event_args/actor/clickchain/clone()
	var/datum/event_args/actor/clickchain/cloned = new(performer, initiator, target, params, intent)
	return cloned
