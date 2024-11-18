
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Processes inbound say.
 */
/mob/proc/saycode_parse(message, saycode_origin)

#warn impl

/mob/say(datum/saycode_packet/packet, datum/saycode_context/context)
	return ..()

/mob/hear(datum/saycode_packet/packet)
	return ..()
