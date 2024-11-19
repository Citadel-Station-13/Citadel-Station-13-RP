//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A holder for saycode data.
 *
 * * Saycode is not just 'say', but also emote, many forms of visible messages, etc.
 * * Saycode is the overall handling chain for complex audiovisual communications - of which saying, and emoting, is a part of.
 */
/datum/saycode_packet
	//* System *//
	/// flagged immutable?
	///
	/// * set to TRUE on send so things editing us don't inadvertently cause race conditions
	var/immutable = FALSE
	/// packet flags
	var/saycode_packet_flags = NONE
	/// overall saycode type
	///
	/// * this is set to a combination of all fragment types.
	var/saycode_type = NONE

	//* Message *//
	/// message fragments
	///
	/// * Text will be interpolated directly as raw HTML.
	/// * /datum/saycode_fragment's will be interpolate()'d as required.
	var/list/fragments

	//* Context *//
	/// Originating turf, if any.
	///
	/// * This is an optional variable.
	var/turf/context_origin_turf
	/// legacy: weakref of real speaker
	///
	/// * speaker will be an /atom/movable
	/// * the speaker is the transmitter, not the origin of the context / whoever parsed a message into the context
	/// * this is called legacy but unlike usual, this is still maintained & allowed to be used. it's just not preerred.
	var/datum/weakref/context_speaker_weakref

#warn impl

/datum/saycode_packet/clone(include_contents)
	var/datum/saycode_packet/packet = new

	packet.saycode_packet_flags = saycode_packet_flags
	packet.saycode_type = saycode_type

	packet.fragments = list()
	for(var/datum/saycode_fragment/fragmentlike in fragments)
		if(istext(fragmentlike))
			packet.fragments += fragmentlike
		else if(istype(fragmentlike))
			packet.fragments += fragmentlike.clone()

	packet.context_origin_turf = context_origin_turf
	packet.context_speaker_weakref = context_speaker_weakref

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
/datum/saycode_packet/proc/perform_render(client/target, force) as text
	if(!target && !force)
		return

	var/raw_html = render()


/**
 * Renders a say into a HTML-formatted message for the chat.
 *
 * * All html, including internal signalling used in tgui-chat like component injection,
 *   should be returned.
 * * This pretty much is the proc that does it all.
 *
 * @return rendered string, or null if fail / skipped
 */
/datum/saycode_packet/proc/render() as text
	// todo: caching
	var/list/joining
