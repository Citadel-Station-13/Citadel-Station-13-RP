
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/say(datum/saycode_packet/packet, datum/saycode_context/context)
	return ..()

/mob/say/transmit_say(datum/saycode_packet/packet, datum/saycode_context/context)
	#warn impl

/mob/hear(datum/saycode_packet/packet)
	. = ..()

	// if no one's home, we don't care
	if(!client)
		return

#warn impl

/**
 * Does what we need to do to hear a message.
 */
/mob/proc/
