//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A holder for saycode data.
 *
 * * Saycode is not just 'say', but also emote, many forms of visible messages, etc.
 * * Saycode is the overall handling chain for complex audiovisual communications - of which saying, and emoting, is a part of.
 */
/datum/saycode_packet
	/// message fragments
	///
	/// * Text will be interpolated directly as raw HTML.
	/// * /datum/saycode_fragment's will be interpolate()'d as required.
	var/list/fragments
	/// overall saycode type
	///
	/// * this is set to a combination of all fragment types.
	var/saycode_type = NONE

	/// legacy: weakref of real speaker
	///
	/// * speaker will be an /atom/movable
	/// * this is called legacy but unlike usual, this is still maintained & allowed to be used. it's just not preerred.
	var/datum/weakref/legacy_speaker_weakref

#warn impl
