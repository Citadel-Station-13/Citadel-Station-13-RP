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

/datum/event_args/actor/proc/chat_feedback(msg, atom/target)
	performer.action_feedback(msg, target)
	if(performer != initiator)
		initiator.action_feedback(msg, target)

/datum/event_args/actor/proc/bubble_feedback(msg, atom/target)
	performer.bubble_action_feedback(msg, target)
	if(performer != initiator)
		initiator.bubble_action_feedback(msg, target)

/**
 * It is highly recommended to use named parameters with this.
 */
/datum/event_args/actor/proc/visible_feedback(atom/target, range, visible, audible, visible_self, otherwise_self, visible_them, otherwise_them)
	performer.visible_action_feedback(
		target = target,
		initiator = initiator,
		hard_range = range,
		visible_hard = visible,
		audible_hard = audible,
		visible_self = visible_self,
		otherwise_self = otherwise_self,
		visible_them = visible_them,
		otherwise_them = otherwise_them,
	)

/**
 * It is highly recommended to use named parameters with this.
 */
/datum/event_args/actor/proc/visible_dual_feedback(atom/target, range_hard, range_soft, visible_hard, visible_soft, audible_hard, audible_soft, visible_self, otherwise_self, visible_them, otherwise_them)
	performer.visible_action_feedback(
		target = target,
		initiator = initiator,
		hard_range = range_hard,
		soft_range = range_soft,
		visible_hard = visible_hard,
		visible_soft = visible_soft,
		audible_hard = audible_hard,
		audible_soft = audible_soft,
		visible_self = visible_self,
		otherwise_self = otherwise_self,
		visible_them = visible_them,
		otherwise_them = otherwise_them,
	)
