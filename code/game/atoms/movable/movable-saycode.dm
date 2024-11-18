//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Lazy API *//

/**
 * Say proc to use when you are too lazy to craft a saycode packet yourself.
 *
 * Message will be automatically parsed.
 *
 * @params
 * * message - Message to send. HTML-allowed.
 */
/atom/movable/proc/lazy_say(message)

#warn impl above/below

//* API *//

/**
 * Transmit a saycode packet.
 *
 * * Make sure you call get_mutable() if you're editing the packet.
 *
 * @params
 * * packet - The transmitting packet.
 * * context - The context to send it with.
 */
/atom/movable/proc/say(datum/saycode_packet/packet, datum/saycode_context/context)
	SHOULD_CALL_PARENT(TRUE)

/**
 * Receive a saycode packet.
 *
 * * Prefiltering will already have ran at this point.
 * * Make sure you call get_mutable() if you're editing the packet.
 *
 * @params
 * * packet - The received packet.
 */
/atom/movable/proc/hear(datum/saycode_packet/packet)
	SHOULD_CALL_PARENT(TRUE)
