/mob/action_feedback(msg, atom/target)
	to_chat(src, msg)

/**
 * gives feedback for doing an action, e.g. using a tool on something
 *
 * use this instead of direct bubble alerts so mob remote control can be done better.
 *
 * @params
 * * msg - what we see/know
 * * target - what we're messing with
 */
/mob/proc/bubble_action_feedback(msg, atom/target)
	// for now, just wrapper for chat action feedback
	action_feedback("[icon2html(target, src)] [SPAN_NOTICE(msg)]")

/**
 * gives feedback to us and someone else
 *
 * @params
 * * msg - what we see
 * * target - what we're messing with
 * * them - what they see
 */
/mob/proc/detectable_action_feedback(msg, atom/target, them)
	ASSERT(them && target)
	action_feedback(msg, target)
	if(!ismob(target))
		return
	to_chat(target, them)

/**
 * gives feedback for something a mob can innately feel, body or not.
 */
/mob/proc/innate_feedback(msg)
	to_chat(src, msg)

/**
 * gives feedback for something a mob can physically feel on their body.
 */
/mob/proc/tactile_feedback(msg)
	to_chat(src, msg)

/**
 * gives feedback for an ui click
 */
/mob/proc/ui_feedback(msg, datum/host, datum/tgui/ui)
	to_chat(src, msg)

/**
 * gives feedback for trying to move/whatever
 */
/mob/proc/selfmove_feedback(msg)
	to_chat(src, msg)
