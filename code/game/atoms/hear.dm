//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! Hear Module
//! Contains all relevant core procs for receiving transmitted messages, visible or audible.

// todo: atom /say()code rewrite

/**
 * receive a visible message or action
 *
 * * called on things with ATOM_HEAR flag.
 * * preprocessing like soft message ranges are processed before.
 * * Ensure the args of this proc match, and are properly indexed by the indices in [code/__DEFINES/procs/saycode.dm]
 * * name / face_ident, if specified, will be added before the message with bold and a space.
 *
 * @params
 * * raw_message - raw message. this might be preformatted HTML.
 * * message - the message. this might be preformatted HTML. this is the one you should edit.
 * * name - if specified, this is the real name of the person or entity that outputted. leave blank to omit name.
 * * face_ident - if specified, this is the facial identifier of the person or entity that outputted. leave blank to omit name. overrides name if used and target has recognition system.
 * * actor - (optional) atom that the message originated from
 * * remote - (optional) this message is not direct, and was relayed. defaults to FALSE.
 */
/atom/proc/see(raw_message, message, name, voice_ident, atom/actor, remote)
	#warn impl

/**
 * hear an audible message or action
 *
 * * called on things with ATOM_HEAR flag.
 * * preprocessing like soft message ranges are processed before.
 * * Ensure the args of this proc match, and are properly indexed by the indices in [code/__DEFINES/procs/saycode.dm]
 * * name / voice_ident, if specified, will be added before the message with bold and a space.
 *
 * @params
 * * raw_message - raw message. this might be preformatted HTML.
 * * message - the message. this might be preformatted HTML. this is the one you should edit.
 */
/atom/proc/hear(raw_message)
	#warn impl

/**
 * receive a direct narration
 *
 * * called on things with ATOM_HEAR flag.
 * * preprocessing like soft message ranges are processed before.
 * * Ensure the args of this proc match, and are properly indexed by the indices in [code/__DEFINES/procs/saycode.dm]
 *
 * @params
 * * raw_message - raw message. this might be preformatted HTML.
 */
/atom/proc/narrate(raw_message)
	#warn impl
