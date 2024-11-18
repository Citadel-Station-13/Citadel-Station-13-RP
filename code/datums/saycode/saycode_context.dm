//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Where `/datum/saycode_packet` stores a message, a saycode context
 * stores the intent of sending that message, like whether to send it over the radio and whatnot.
 */
/datum/saycode_context
	/// our packet to send, if any.
	///
	/// * This is often un-referenced during send. Saycode procs should always accept a packet and a context separately if
	///   a proc needs a context.
	var/datum/saycode_packet/packet

	/// the decorator used.
	///
	/// * determines speech bubble
	var/decorator = SAYCODE_DECORATOR_STATEMENT

#warn impl
