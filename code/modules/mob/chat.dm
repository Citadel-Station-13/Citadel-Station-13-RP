/**
 * gives feedback for doing an action, e.g. using a tool on something
 *
 * use this instead of direct to_chats so mob remote control can be done better.
 */
/mob/proc/chat_action_feedback(msg)
	to_chat(src, msg)

/**
 * gives feedback for doing an action, e.g. using a tool on something
 *
 * use this instead of direct bubble alerts so mob remote control can be done better.
 */
/mob/proc/bubble_action_feedback(msg, atom/target)
	// for now, just wrapper for chat action feedback
	chat_action_feedback(SPAN_NOTICE(msg))
