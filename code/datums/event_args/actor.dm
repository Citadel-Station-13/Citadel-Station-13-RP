/**
 * used to hold semantic data about an action being done by an actor vs initiator (controller)
 */
/datum/event_args/actor
	/// the mob performing the action
	var/mob/performer
	/// the mob actually initiating the action, e.g. a remote controller.
	var/mob/initiator

/datum/event_args/actor/New(mob/performer, mob/initiator)
	src.performer = performer
	src.initiator = isnull(initiator)? performer : initiator
