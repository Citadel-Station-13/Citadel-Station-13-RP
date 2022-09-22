/**
 * gives feedback for doing an action, e.g. using a tool on something
 *
 * use this instead of direct to_chats so mob remote control can be done better.
 *
 * @params
 * - msg - what we see/know
 * - target - what we're messing with
 */
/mob/proc/action_feedback(msg, atom/target)
	to_chat(src, msg)

/**
 * gives feedback for doing an action, e.g. using a tool on something
 *
 * use this instead of direct bubble alerts so mob remote control can be done better.
 *
 * @params
 * - msg - what we see/know
 * - target - what we're messing with
 */
/mob/proc/bubble_action_feedback(msg, atom/target)
	// for now, just wrapper for chat action feedback
	action_feedback(SPAN_NOTICE(msg))

/**
 * gives feedback to us and someone else
 *
 * @params
 * - msg - what we see
 * - target - what we're messing with
 * - them - what they see
 */
/mob/proc/detectable_action_feedback(msg, atom/target, them)
	ASSERT(them && target)
	action_feedback(msg, target)
	if(!ismob(target))
		return
	to_chat(target, them)

/**
 * gives feedback for an action we're doing and makes it visible for everyone around us too.
 *
 * @params
 * - msg - what everyone sees by default
 * - target - what we're messing with
 * - range - how far to display; defaults to loud range
 * - self - what we see
 * - them - what they see
 * - blind - what blind people see (overridden by self and them if specified)
 */
/mob/proc/visible_action_feedback(others, atom/target, range = MESSAGE_RANGE_COMBAT_LOUD, self, them, blind)
	visible_message(others, self, blind, range)
