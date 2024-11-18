
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_REAL(saycode_emphasis_parser, /regex) = regex(
	@{"(\+|\||_|~)(?=\\S)(.+?)(?=\\S)\1"},
	"g",
)

/proc/zz__saycode_emphasis_parser(match, group_1, group_2)
	var/static/list/lookup = list(
		"+" = "b",
		"~" = "s",
		"_" = "u",
		"|" = "i",
	)
	var/use_html_tag = lookup[group_1]
	return "<[use_html_tag]>[group_2]</[use_html_tag]>"

/**
 * Processes inbound say.
 *
 * * This should be done from the PoV / handling of the current mob, even if it's
 *   going to go somewhere else!
 * * As an example, if you're trying to talk through a holopad, this is what processes it,
 *   then sends the completed context to the holopad.
 * * It's done this way because the say / message is being thought out by the sender,
 *   and is then acted out by the receiver. This way you can have fun situations where you
 *   can talk with another language through someone you are controlling despite them
 *   not knowing that language.
 *
 * @params
 * * message - message to parse
 * * origin - SAYCODE_ORIGIN_* enum
 */
/mob/proc/saycode_parse(message, origin) as /datum/saycode_context
	/**
	 * This is the authoritative documentation on Citadel RP's say syntax.
	 *
	 * If anything changes, the help entry **must** be changed as well!
	 *
	 * * Say / Emote should have similar syntax so players don't need to memorize two sets.
	 * * Normal say emphasis will not hold up a message. If it fails to parse, it fails to parse.
	 *   This is because we expect players to use it in the heat of the moment, and an intrusive
	 *   popup stealing focus mid-combat is bad.
	 * * Special say commands like #e{use language on 'e' language key} and ${self}, will make a parse
	 *   fail and reflect.
	 *
	 * * ------ COMMON ------ *
	 *
	 * This is in order of application.
	 *
	 * > Emphasis <
	 *
	 * * Emphasis is done via regex.
	 * * Emphasis markers must be adjacent to letters to work;
	 *   this way, we do not trample things like math equations.
	 *
	 * "The ~quick~ +brown+ |fox| jumps over the _lazy_ dog."
	 *
	 * 'brown' is bolded.
	 * 'fox' is italicized.
	 * 'lazy' is underlined.
	 * 'quick' is strikethrough'd.
	 *
	 * * ------ SAY ------ *
	 *
	 * * A say'd message does not allow using entirely non-verbal languages due to
	 *   there not being a good way to render it in the message when passed over radio.
	 * * Non-verbal component languages, however, can be used - they'll be garbled as usual.
	 *
	 * > Emote Invocation Hook <
	 *
	 * If the first character of the message is `*`, it will always be sent to the emote
	 * system for processing.
	 *
	 * Example: "*smile"
	 *
	 * > Custom Emote Hook <
	 *
	 * If the first character of the message is '^', it will be sent verbatim
	 * to the custom emote parser instead.
	 *
	 * Example: "^..." ; anything after ther ^ is sent to emote as if they typed it into an emote.
	 *
	 * > Transmit Key <
	 *
	 * Transmit key will be parsed as follows.
	 *
	 * `;` - common.
	 * `:k` - transmit with `k` key. Not case sensitive.
	 * `.k` - transmit with 'k' key. Not case sensitive.
	 *
	 * > Language Key <
	 *
	 * Language key will be parsed as follows.
	 *
	 * `,k` for language with key 'k'. Not case sensitive.
	 *
	 * > -- Rest -- <
	 *
	 * After the above, the rest of the message will be sent with the above parameters.
	 *
	 * > Language Fragments <
	 *
	 * One may include language fragments by doing the following.
	 *
	 * "The quick brown fox #e{jumps over} the lazy dog."
	 * In this example, 'jumps over' is using a language with the given key of 'e'.
	 *
	 * > -- Footer -- <
	 *
	 * After all of the above, the last parts of the message is handled as following.
	 *
	 * * If '?' is encountered at the end, the message is considered a question.
	 * * If '!' is encountered at the end, the message is considered an exclamation.
	 * * If '!!' is encountered at the end, the message is considered yelling.
	 *
	 * * ------ EMOTE ------ *
	 *
	 * * Emotes immediately begin the message segment.
	 * * Emotes allow a given amount of newlines to be used.
	 *
	 * > Language Fragments <
	 *
	 * * Same as fragments in the Say section.
	 * * Languages in emotes fully support all languages, whether verbal or nonverbal.
	 *
	 * > Actor Name Position <
	 *
	 * If "${self}" is encountered (literal), the implementation may include the actor's name
	 * there instead of at the start of the message.
	 */

	var/static/char_sanity_limit = 8192
	var/static/byte_safety_limit = 8192 * 4
	var/static/newline_sanity_limit = 24

	if(length(message) > byte_safety_limit)
		log_saycode_parse(src, "unsafe too long ([length(message)] > [byte_safety_limit])")
		return new /datum/saycode_context/failure("Message was too long to safely process (>= [byte_safety_limit]B) and was entirely dropped.")

	var/message_length = length_char(message)
	var/datum/saycode_context/creating_context = new

	if(message_length > char_sanity_limit)
		log_saycode_parse(src, "safe too long ([message_length] > [char_sanity_limit]); reflected: '[message]'")
		return new /datum/saycode_context/failure("Message too long (>= [char_sanity_limit] characters).")

	var/start_tu = TICK_USAGE

	// say: handle overrides
	switch(origin)
		if(SAYCODE_ORIGIN_SAY, SAYCODE_ORIGIN_WHISPER)
			var/first_character_override_say_maybe = copytext_char(message, 1, 2)
			switch(first_character_override_say_maybe)
				if("^")
					origin = (origin == SAYCODE_ORIGIN_WHISPER) ? SAYCODE_ORIGIN_SUBTLE : SAYCODE_ORIGIN_SAY
				if("*")
					#warn custom emote

	// common: parse emphasis into embedded HTML tags
	message = replacetext_char(message, global.saycode_emphasis_parser, /proc/zz__saycode_emphasis_parser)

	switch(origin)
		if(SAYCODE_ORIGIN_SAY, SAYCODE_ORIGIN_WHISPER)
			// treated as a say

			// -- handle mode key --

			// -- handle message key --

			// -- parse message --
			var/static/regex/say_parser = regex(
				"",
				"g",
			)
			say_parser.next = 1
			while(say_parser.Find_char(message))

			// -- handle footer --
			if(message)
				switch(copytext_char(message, -1))
					if("!")
						var/yelling = copytext_char(message, -2, -1) == "!"
						if(yelling)
							creating_context.decorator = SAYCODE_DECORATOR_YELL
						else
							creating_context.decorator = SAYCODE_DECORATOR_EXCLAIM
					if("?")
						creating_context.decorator = SAYCODE_DECORATOR_QUESTION
		if(SAYCODE_ORIGIN_EMOTE, SAYCODE_ORIGIN_SUBTLE, SAYCODE_ORIGIN_SUBTLER)
			// treated as an emote

			// -- parse message --
			var/static/regex/emote_parser = regex(
				"",
				"g",
			)
			emote_parser.next = 1
			while(emote_parser.Find_char(message))

	var/end_tu = TICK_USAGE
	log_saycode_parse(src, TICK_USAGE_TO_MS(end_tu - start_tu), message)
	return creating_context

#warn impl

/mob/verb/saycode_help()
	set name = "Help - Say / Emote"
	set category = VERB_CATEGORY_SYSTEM

	// common:
	// +bold+ |italics| _underscore_ ~strikethrough~

	// say:
	// emote command hook: "*"
	// custom emote hook: "^"
	// transmit key: ":k" or ".k" for case insensitive 'k' key.
	// language key: ",k" for case insensitive 'k' key.
	// language fragment: "#k{text}" for case insensitive 'k' key.

#warn impl help entry

/mob/say(datum/saycode_packet/packet, datum/saycode_context/context)
	return ..()

/mob/hear(datum/saycode_packet/packet)
	return ..()
