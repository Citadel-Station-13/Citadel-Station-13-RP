//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A fragment of saycode data. Goes with `/datum/saycode_packet`
 */
/datum/saycode_fragment
	/// message that comprises this
	var/message
	/// the list of spans, as raw text, to apply to the message
	var/list/spans
	/// language id of message
	var/language_id = /datum/language/common::id
	/// saycode type; uses SAYCODE_TYPE_* defines.
	///
	/// * This means that a message can theoretically have multiple different saycode types.
	var/saycode_type = SAYCODE_TYPE_ALWAYS

/datum/saycode_fragment/clone(include_contents)
	var/datum/saycode_fragment/fragment = new
	fragment.message = message
	fragment.spans = spans?.Copy()
	fragment.language_id = language_id
	fragment.saycode_type = saycode_type
	return fragment

/**
 * Interpolates us into text.
 *
 * * This should be 100% deterministic based on arguments and parameters.
 */
/datum/saycode_fragment/proc/interpolate() as text
	return message

#warn impl
