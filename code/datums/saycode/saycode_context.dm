//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Where `/datum/saycode_packet` stores a message, a saycode context
 * stores the intent of sending that message, like whether to send it over the radio and whatnot.
 */
/datum/saycode_context
	//* Message *//
	/// our packet to send, if any.
	///
	/// * This is often un-referenced during send. Saycode procs should always accept a packet and a context separately if
	///   a proc needs a context.
	var/datum/saycode_packet/packet

	//* Header *//
	/// Detected transmit key.
	var/header_transmit_key

	//* Footer *//
	/// the decorator used.
	///
	/// * determines speech bubble
	var/footer_decorator = SAYCODE_DECORATOR_STATEMENT

	/// were we rejected?
	var/reject = FALSE
	/// rejection reason
	var/reject_reason = "Unknown reason. Contact admins / coders for help!"
	/// estimated rejection position, if any
	var/reject_position
	/// raw text to reflect back
	var/reject_reflect

#warn impl

/datum/saycode_context/failure

/datum/saycode_context/failure/New(reason, position, reflect)
	..()
	if(reason)
		src.reject_reason = reason
	if(position)
		src.reject_position = position
	if(reflect)
		src.reject_reflect = reflect
