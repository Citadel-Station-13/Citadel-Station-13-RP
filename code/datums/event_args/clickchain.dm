/**
 * used to hold data about a click action
 */
/datum/event_args/clickchain
	/// the mob performing the action
	var/mob/performer
	/// the mob actually initiating the action, e.g. a remote controller.
	var/mob/initiator
	/// a_intent
	var/intent
	/// click params
	var/list/params

/datum/event_args/clickchain/New(mob/performer, mob/initiator, intent, list/params)
	src.performer = performer
	src.initiator = isnull(initiator)? performer : initiator
	src.intent = isnull(intent)? performer.a_intent : intent
	src.params = isnull(params)? list() : params
