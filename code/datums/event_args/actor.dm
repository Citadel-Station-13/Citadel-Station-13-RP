//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: mob.generate_simulated_actor(...)

/**
 * used to hold semantic data about an action being done by an actor vs initiator (controller)
 */
/datum/event_args/actor
	/// arbitrary data list
	/// * this is a lazy list
	/// * this will be logged, don't be too verbose
	/// * only primitives (text / numbers / lists, no datums) are allowed in here, including inside nested lists.
	var/list/data = list()
	/// Is this a simulated event?
	/// * This is used for logging.
	/// * This should be set to TRUE if this didn't originate from a player's client.
	var/simulated = FALSE
	/// the mob performing the action
	var/mob/performer
	/// the mob actually initiating the action, e.g. a remote controller.
	var/mob/initiator

/datum/event_args/actor/New(mob/performer, mob/initiator)
	src.performer = performer
	src.initiator = initiator || performer

/datum/event_args/actor/clone()
	var/datum/event_args/actor/cloning = new type
	cloning.performer = performer
	cloning.initiator = initiator
	cloning.simulated = simulated
	cloning.data = deep_copy_list(data)
	return cloning

//* Logging *//

/datum/event_args/actor/proc/actor_log_string()
	return performer == initiator ? key_name(performer) : "[key_name(performer)] (via [key_name(initiator)])"

//* Feedback *//

/datum/event_args/actor/proc/chat_feedback(msg, atom/target)
	performer.action_feedback(msg, target)
	if(performer != initiator)
		initiator.action_feedback(msg, target)

/datum/event_args/actor/proc/bubble_feedback(msg, atom/target)
	performer.bubble_action_feedback(msg, target)
	if(performer != initiator)
		initiator.bubble_action_feedback(msg, target)

// todo: rework these awful ass feedback/message procs below wtf

// proposal:
// visible_feedback(visible, audible, self, range, target)
// visible_proximity_feedback(visible_far, visible_near, audible_far, audible_near, self, range_far, range_near, target)

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
