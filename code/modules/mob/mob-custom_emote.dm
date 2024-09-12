//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Custom Emote *//
/**
 * This module is used for processing custom emotes.
 */

/**
 * Relay a raw incoming custom emote
 */
/mob/proc/run_custom_emote(emote_text, subtle, anti_ghost)
	SHOULD_NOT_OVERRIDE(TRUE)
	#warn impl

/**
 * Perform special preprocessing on an incoming custom emote
 */
/mob/proc/process_custom_emote(emote_text, subtle, anti_ghost)
	return emote_text

/**
 * Emit a custom emote
 */
/mob/proc/emit_custom_emote(emote_text, subtle, anti_ghost)
	#warn impl
