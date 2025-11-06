//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Say *//

/**
 * Prompts for a say
 */
/mob/verb/say_wrapper()
	set name = "say-indicator"
	set category = null
	set hidden = TRUE

	set_typing_indicator(TRUE)
	var/message = input(src, "", "say (text)") as text|null
	set_typing_indicator(FALSE)
	if(!message)
		return

	say_verb(message)

/mob/verb/say_verb(message as text)
	set name = "Say"
	set desc = "Say something to people who you can see."
	set category = VERB_CATEGORY_IC

	// ensure length isn't too high
	message = sanitize_or_reflect(message, src, encode = FALSE)
	if(!message)
		return
	// clear typing indicator
	set_typing_indicator(FALSE)
	// perform say
	say(message)

//* Whisper *//

/**
 * Prompts for a whisper
 */
/mob/verb/whisper_wrapper()
	set name = "whisper-indicator"
	set category = null
	set hidden = TRUE

	var/message = input(src, "", "whisper (text)") as text|null
	if(!message)
		return

	whisper_verb(message)

/mob/verb/whisper_verb(message as text)
	set name = "Whisper"
	set desc = "Whisper something to people next to you."
	set category = VERB_CATEGORY_IC

	// ensure length isn't too high
	message = sanitize_or_reflect(message, src, encode = FALSE)
	if(!message)
		return
	// clear typing indicator
	set_typing_indicator(FALSE)
	// perform say
	whisper(message)

//* Emote *//

/**
 * Prompts for a custom emote; uses typing indicator
 */
/mob/verb/me_wrapper()
	set name = "me-indicator"
	set category = null
	set hidden = TRUE

	set_typing_indicator(TRUE)
	var/message = input(src, "", "me (text)") as message|null
	set_typing_indicator(FALSE)
	if(!message)
		return

	me_verb(message)

/mob/verb/me_verb(message as message)
	set name = "Me"
	set desc = "Emote to people in view."
	set category = VERB_CATEGORY_IC

	// ensure length isn't too high
	message = sanitize_or_reflect(message, src, encode = FALSE)
	if(!message)
		return
	// clear typing indicator
	set_typing_indicator(FALSE)
	// perform emote
	run_custom_emote(message, FALSE, FALSE, SAYCODE_TYPE_ALWAYS, with_overhead = TRUE)

//* Subtle Emote *//

/**
 * Prompts for a subtle
 */
/mob/verb/subtle_wrapper()
	set name = "subtle-wrapper"
	set category = null
	set hidden = TRUE

	var/message = input(src, "", "subtle (text)") as message|null
	if(!message)
		return

	subtle_verb(message)

/mob/verb/subtle_verb(message as message)
	set name = "Subtle"
	set desc = "Emote to people within 1 tile (3x3) of (or inside) yourself."
	set category = VERB_CATEGORY_IC

	// ensure length isn't too high
	message = sanitize_or_reflect(message, src, encode = FALSE)
	if(!message)
		return
	// clear typing indicator
	set_typing_indicator(FALSE)
	// perform emote
	run_custom_emote(message, TRUE, FALSE, SAYCODE_TYPE_ALWAYS)

//* Subtler Anti Ghost Emote *//

/**
 * Prompts for a subtle
 */
/mob/verb/subtler_anti_ghost_wrapper()
	set name = "subtle-anti-ghost-wrapper"
	set category = null
	set hidden = TRUE

	var/message = input(src, "", "subtler-anti-ghost (text)") as message|null
	if(!message)
		return

	subtler_anti_ghost_verb(message)

/mob/verb/subtler_anti_ghost_verb(message as message)
	set name = "Subtler Anti-Ghost"
	set desc = "Emote to people within 1 tile (3x3) of (or inside) yourself. Ghosts cannot see this."
	set category = VERB_CATEGORY_IC

	// ensure length isn't too high
	message = sanitize_or_reflect(message, src, encode = FALSE)
	if(!message)
		return
	// clear typing indicator
	set_typing_indicator(FALSE)
	// perform emote
	run_custom_emote(message, TRUE, TRUE, SAYCODE_TYPE_ALWAYS)
