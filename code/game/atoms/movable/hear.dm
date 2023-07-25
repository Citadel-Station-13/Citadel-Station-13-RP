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
 * * actor - (optional) atom that the message originated from. you should not be reading name off of this.
 * * remote - (optional) this message is not direct, and was relayed. defaults to FALSE. cameras count as this.
 *
 * @return successful see? mob logged out is still successful because the *mob* saw it, even if the *player* didn't get it.
 */
/atom/movable/proc/see(raw_message, message, name, face_ident, atom/actor, remote)
	SHOULD_CALL_PARENT(TRUE)
	if(isnull(message))
		message = raw_message
	SEND_SIGNAL(src, COMSIG_MOVABLE_SEE, args)

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
 * * name - if specified, this is the real voice name of the person or entity that emitted this message. leave blank to omit name.
 * * voice_ident - if specified, this is the voice identifier of the person or entity that outputted. leave blank to omit name. overrides name if used and target has recognition system.
 * * actor - (optional) atom that the message originated from. you should not be reading name off of this.
 * * remote - (optional) this message is not direct, and was relayed. defaults to FALSE. radio counts as this.
 * * lang - (optional) language used. this is /datum/language/audible_action if it's an audible emote.
 * * spans - list of span classes to use. this will wrap the entire message without wrapping the name.
 * * params - list of say parameters associated to value. this is for arbitrary behavior. this list should be read only, as it's a shared list.
 *
 * @return successful hear? mob logged out is still successful because the *mob* heard it, even if the *player* didn't get it.
 */
/atom/movable/proc/hear(raw_message, message, name, voice_ident, atom/movable/actor, remote, datum/language/lang, list/spans, list/params)
	SHOULD_CALL_PARENT(TRUE)
	if(isnull(message))
		message = raw_message
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)

/**
 * receive a direct narration
 *
 * * called on things with ATOM_HEAR flag.
 * * preprocessing like soft message ranges are processed before.
 * * Ensure the args of this proc match, and are properly indexed by the indices in [code/__DEFINES/procs/saycode.dm]
 *
 * @params
 * * raw_message - raw message. this might be preformatted HTML.
 *
 * @return successful narration? mob logged out is still successful because the *mob* got it, even if the *player* didn't.
 */
/atom/movable/proc/narrate(raw_message)
	return
