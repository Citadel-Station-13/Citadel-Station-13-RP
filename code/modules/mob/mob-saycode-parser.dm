
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_REAL(saycode_emphasis_parser, /regex) = regex(
	@{"(\+|\||_|~)(?=\\S)(.+?)(?=\\S)\1"},
	"g",
)

/**
 * Used by GLOB.saycode_emphasis_parser to parse the following wraps:
 *
 * +bold+
 * |italics|
 * _underline_
 * ~strikethrough~
 */
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
 * Processes an attempt to say something.
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
 * * strict mode - reject on error instead of proceeding
 */
/mob/proc/saycode_parse(message, origin, strict) as /datum/saycode_context
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
	 * * ------ SYNTAX ------ *
	 *
	 * Citadel RP's saycode's language is as follows.
	 *
	 * <message> ::= <override> <header> <body> <footer>
	 *
	 * <override> ::= "*" | "^" | ""
	 * <header> ::= <header-part> | <header> <header-part>
	 * <header-part> ::= ";" | <transmit-invoke> <transmit-key> | "," <language-mode> | "!"
	 * <transmit-invoke> ::= '.' | ':'
	 *
	 * <body> ::= <body-fragment> <body> | <body-fragment>
	 * <body-fragment> ::= <symbol> | <language-fragment> | <text>
	 * <symbol> ::= "${" <identifier> "}"
	 * <language-fragment> ::= "#" <identifier> "{" <body-fragment> "}"
	 *
	 * <footer> ::= "" | "." | <exclaim> | "?"
	 * <exclaim> ::= "!" | <exclaim" "!"
	 *
	 * <text> ::= (string) | <emphasis> (string) <emphasis>
	 * <emphasis> ::= "+" | "|" | "_" | "~"
	 *
	 * Override:
	 * '*' = run emote command
	 * '^' = convert say to emote ('me' verb)
	 *
	 * Header:
	 * ";" = transmit to designated-common radio of headset
	 * ",e" = set default language to language of e key
	 * ":e" = transmit with e key
	 * ".e" = transmit with e key
	 * "!" = set default language to 'audible noise' language
	 *
	 * Body:
	 * "${identifier}" to invoke a special function
	 * "#identifier{...}" to language-wrap
	 * "+bold+", "|italics|", "_underline_", "~strikethrough~"
	 *
	 * Footer:
	 * "!!" to yell; ! can be repeated.
	 * "!" to exclaim
	 * "?" to question
	 * "." to state (default)
	 *
	 * Technically, say and emote parse differently; the above is a combined approximation
	 * of what's going on.
	 *
	 * What this means:
	 *
	 * * Header has unique prefixes for everything, and deterministic length.
	 *   We can parse the header with a simple loop.
	 * * Footer has deterministic length and cannot contain body fragments.
	 *   We handle it last, and it's also agnostic to whether or not we detected however
	 *   many body fragments. This makes it very simply to do via copytext_char().
	 * * Body is parsed with a pushdown automata.
	 *
	 * * ------ SAY ------ *
	 *
	 * * A say'd message does not allow using entirely non-verbal languages due to
	 *   there not being a good way to render it in the message when passed over radio.
	 * * Non-verbal component languages, however, can be used - they'll be garbled as usual.
	 *
	 * * ------ EMOTE ------ *
	 *
	 * * Emotes immediately begin the message segment.
	 * * Emotes allow a given amount of newlines to be used.
	 */

	var/static/char_sanity_limit = 8192
	var/static/byte_safety_limit = 8192 * 4
	var/static/newline_sanity_limit = 24
	var/static/fragment_safety_limit = 32
	var/static/token_safety_limit = 32 * 4

	// length enforcements
	if(length(message) > byte_safety_limit)
		log_saycode_parse(src, "unsafe too long ([length(message)] > [byte_safety_limit])")
		return new /datum/saycode_context/failure("Message was too long to safely process (>= [byte_safety_limit]B) and was entirely dropped.")

	var/message_length = length_char(message)
	if(message_length > char_sanity_limit)
		log_saycode_parse(src, "safe too long ([message_length] > [char_sanity_limit]); reflected: '[message]'")
		return new /datum/saycode_context/failure("Message too long (>= [char_sanity_limit] characters).")

	// begin parsing
	var/start_tu = TICK_USAGE
	var/datum/saycode_context/creating_context = new
	var/parse_position = 0
	var/header_parse_character

	// trim
	message = trim(message)

	// parse: <override>
	header_parse_character = copytext_char(message, 1, 2)
	switch(header_parse_character)
		if("^")
			++parse_position
			origin = (origin == SAYCODE_ORIGIN_WHISPER) ? SAYCODE_ORIGIN_SUBTLE : SAYCODE_ORIGIN_SAY
		if("*")
			++parse_position
			origin = SAYCODE_ORIGIN_REDIRECT_TO_EMOTE

	// set origin
	creating_context.origin = origin

	// if redirecting, just pass rest back. caller should handle redirects.
	if(origin & (SAYCODE_ORIGINS_FOR_REDIRECT))
		creating_context.origin_redirect_with = copytext_char(message, parse_position + 1)
		return creating_context

	// parse: <header>
	var/header_transmit_key
	var/header_language_key
	while((header_parse_character = copytext_char(message, parse_position + 1, parse_position + 2)))
		switch(header_parse_character)
			if("!")
				if(!(origin & (SAYCODE_ORIGIN_SAY | SAYCODE_ORIGIN_WHISPER)))
					log_saycode_reject(src, "audible mode on emote", message)
					return new /datum/saycode_context/failure("Cannot set audible mode on an emote message.", parse_position, message)
				if(!isnull(header_language_key))
					log_saycode_reject(src, "duplicate language key (noise)", message)
					return new /datum/saycode_context/failure("Duplicate language key.", parse_position, message)
				header_language_key = "!"
				++parse_position
			if(",")
				if(!(origin & (SAYCODE_ORIGIN_SAY | SAYCODE_ORIGIN_WHISPER)))
					log_saycode_reject(src, "language key on emote", message)
					return new /datum/saycode_context/failure("Cannot set global language on an emote message.", parse_position, message)
				if(!isnull(header_language_key))
					log_saycode_reject(src, "duplicate language key", message)
					return new /datum/saycode_context/failure("Duplicate language key.", parse_position, message)
				header_language_key = copytext_char(message, parse_position + 2, parse_position + 3)
				parse_position += 2
			if(":", ".")
				if(!(origin & (SAYCODE_ORIGIN_SAY | SAYCODE_ORIGIN_WHISPER)))
					log_saycode_reject(src, "transmit mode on emote", message)
					return new /datum/saycode_context/failure("Cannot set transmit mode on an emote message.", parse_position, message)
				if(!isnull(header_transmit_key))
					log_saycode_reject(src, "duplicate transmit key", message)
					return new /datum/saycode_context/failure("Duplicate transmit key.", parse_position, message)
				header_transmit_key = copytext_char(message, parse_position + 2, parse_position + 3)
				parse_position += 2

	creating_context.header_transmit_key = header_transmit_key
	#warn handle header language key

	// parse: <body>

	/**
	 * body parsing; the three major parts is parsing:
	 *
	 * * emphasis - mostly font style modifications the user can call
	 * * languages - generates new fragments when done
	 * * symbols - generates new fragments when done
	 *
	 * emphasis is parsed first, to generate embedded HTML tags.
	 * afterwards, a custom parser parses languages and symbols in one go,
	 * to avoid needing to manually parse every language fragment.
	 */

	// parse emphasis into HTML
	message = replacetext_char(message, global.saycode_emphasis_parser, /proc/zz__saycode_emphasis_parser)
	// tokenize
	/**
	 * Valid outputs of this regex:
	 * * '#...{' where '...' is 0 to n alphanumeric-plus-dash-and-underscore characters
	 * * '${...}'
	 * * '}'
	 */
	var/static/regex/tokenizer_regex = regex(
		@{"(#[\w\-]*{|${[\w\-]}|})"},
	)
	while(tokenizer_regex.Find_char())

	var/list/tokenized_body = zz__saycode_tokenizer(message, parse_position + 1)
	if(length(tokenized_body) > token_safety_limit)
		log_saycode_reject(src, "safe rejection of token limit [length(tokenized_body) > token_safety_limit]", message)
		return new /datum/saycode_context/failure("Token limit reached.", null, message)
	for(var/token in tokenized_body)
		switch(length(token))
			if()

	// parse: <footer>
	switch(copytext_char(message, -1))
		if("!")
			var/yelling = copytext_char(message, -2, -1) == "!"
			if(yelling)
				creating_context.footer_decorator = SAYCODE_DECORATOR_YELL
			else
				creating_context.footer_decorator = SAYCODE_DECORATOR_EXCLAIM
		if("?")
			creating_context.footer_decorator = SAYCODE_DECORATOR_QUESTION

	// finish parsing
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
	// language key: ",k" for case insensitive 'k' key. "!" for noise.
	// language fragment: "#k{text}" for case insensitive 'k' key.

#warn impl help entry
