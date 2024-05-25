/**
 * event args for clickchain procs
 *
 * clickchain is attack_x with item procs, attack hand, unarmed/ranged, etc.
 */
/datum/event_args/actor/clickchain
	/// the original atom target of the action
	var/atom/target
	/// a_intent
	var/intent
	/// click params
	var/list/params
	/// hand index, if any
	var/hand_index
	/// with item, if any
	var/obj/item/using

/datum/event_args/actor/clickchain/New(mob/performer, mob/initiator, atom/target, intent, list/params)
	..()
	src.target = target
	src.intent = isnull(intent)? performer.a_intent : intent
	src.params = isnull(params)? list() : params
