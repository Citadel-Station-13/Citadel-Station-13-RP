/**
 * event args for clickchain procs
 *
 * clickchain is attack_x with item procs, attack hand, unarmed/ranged, etc.
 */
/datum/event_args/clickchain
	/// the mob that initiated the action - you usually don't care about this unless you're logging
	var/mob/initiator
	/// the mob that is doing the action
	var/mob/actor
	/// the original atom target of the action
	var/atom/target
	/// original click params as list - can be null
	var/list/click_params
	/// attack intent
	var/attack_intent
	/// hand index, if any
	var/hand_index
	/// with item, if any
	var/obj/item/using
