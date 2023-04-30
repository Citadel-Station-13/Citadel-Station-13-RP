/**
 * todo: finish; these are just stubs
 *
 * Hivemind contexts control how languages with special sending methods process speech.
 * They don't necessarily have to be for actual hiveminds;
 * "broadcast to someone you're grabbing/have a brain parasite in" is just as valid.
 *
 * todo: probably need raw say args (??) and retval for if we should pass through to normal say
 * todo: this probably needs a saycode rewrite to be sane
 */
/datum/hivemind_context

/datum/hivemind_context/proc/broadcast(atom/movable/speaker, message, ...)

/datum/hivemind_context/proc/get_listeners()

/datum/hivemind_context/proc/send(atom/movable/listener, message, ...)
