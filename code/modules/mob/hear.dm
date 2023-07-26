//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/mob/see_action(raw_message, message, name, face_ident, atom/actor, remote, list/params)
	..()
	return mob_see_action(arglist(args))

/mob/hear_say(raw_message, message, name, voice_ident, atom/actor, remote, list/params, datum/language/lang, list/spans, say_verb)
	..()
	return mob_hear_say(arglist(args))

/mob/narrate_to(raw_message)
	..()
	. = TRUE
	// todo: redirection support
	if(client)
		to_chat(client, raw_message)

/mob/proc/mob_see_action(raw_message, message, name, face_ident, atom/actor, remote, list/params)
	if(is_blind())
		return FALSE

	#warn mob_see

/mob/proc/mob_hear_say(raw_message, message, name, voice_ident, atom/actor, remote, list/params, datum/language/lang, list/spans, say_verb)
	// todo: rework teleop
	if(!client && !teleop)
		// "send complaints to /dev/null"
		return TRUE

	// check if air can transmit speech - hearer's side
	if(!mob_hear_pressure_check(args))
		// full fail
		return FALSE

	#warn mob_hear

	// encode language
	if((lang.language_flags & LANGUAGE_EVERYONE) && !say_understands(actor, lang))
		mob_hear_language_scramble(args)

	// encode emphasis
	message = saycode_emphasis(message)

/mob/proc/mob_hear_encode_name(list/hear_args)
	#warn impl

/mob/proc/mob_hear_pressure_check(list/hear_args)
	return TRUE

/mob/proc/mob_hear_language_scramble(list/hear_args)
	return
