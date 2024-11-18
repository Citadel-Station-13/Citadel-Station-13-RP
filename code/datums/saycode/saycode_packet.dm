//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A holder for saycode data.
 *
 * * Saycode is not just 'say', but also emote, many forms of visible messages, etc.
 * * Saycode is the overall handling chain for complex audiovisual communications - of which saying, and emoting, is a part of.
 */
/datum/saycode_packet
	/// flagged immutable?
	///
	/// * set to TRUE on send so things editing us don't inadvertently cause race conditions
	var/immutable = FALSE
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

/datum/saycode_packet/clone(include_contents)
	var/datum/saycode_packet/packet = new
	packet.fragments = list()
	for(var/datum/saycode_fragment/fragmentlike in fragments)
		if(istext(fragmentlike))
			packet.fragments += fragmentlike
		else if(istype(fragmentlike))
			packet.fragments += fragmentlike.clone()
	packet.saycode_type = saycode_type
	packet.legacy_speaker_weakref = legacy_speaker_weakref
	return packet

/**
 * Get a mutable version - this may be ourselves or a clone.
 */
/datum/saycode_packet/proc/get_mutable()
	return immutable ? clone() : src



/**
 * Renders a say into a HTML-formatted message for the chat.
 *
 * @params
 * * context - the saycode context to use, if any
 * * target - client that's going to view us
 * * force - render, even if no client is provided
 *
 * @return rendered string, or null if fail / skipped
 */
/datum/saycode_packet/proc/perform_render(datum/saycode_context/context, client/target, force) as text
	if(!target && !force)
		return

	// todo: caching
	var/list/joining


/**
 * Renders a say into a HTML-formatted message for the chat.
 *
 * @params
 * * context - the saycode context to use, if any
 *
 * @return rendered string, or null if fail / skipped
 */
/datum/saycode_packet/proc/render(datum/saycode_context/context) as text
	if(!target && !force)
		return

	// todo: caching
	var/list/joining
