/**
 * used to hold data about a click action
 */
/datum/event_args/actor/clickchain
	/// a_intent
	var/intent
	/// click params
	var/list/params

/datum/event_args/actor/clickchain/New(mob/performer, mob/initiator, intent, list/params)
	..()
	src.intent = isnull(intent)? performer.a_intent : intent
	src.params = isnull(params)? list() : params
