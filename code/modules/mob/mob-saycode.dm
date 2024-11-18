
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Processes inbound say.
 *
 * * This should be done from the PoV / handling of the current mob, even if it's
 *   going to go somewhere else!
 * * As an example, if you're trying to talk through a holopad, this is what processes it,
 *   then sends the completed context to the holopad.
 * * It's done this way because the say / message is being thought out by the sender,
 *   and is then acted out by the receiver. This way you can have fun situations where you
 *   can talk with another language through someone you are controlling despite them
 *   not knowing that language.
 */
/mob/proc/saycode_parse(message, saycode_origin) as /datum/saycode_context

#warn impl

/mob/say(datum/saycode_packet/packet, datum/saycode_context/context)
	return ..()

/mob/hear(datum/saycode_packet/packet)
	return ..()
