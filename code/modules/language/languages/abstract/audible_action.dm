/// Separate global singleton used in saycode
GLOBAL_DATUM_INIT(audible_action_language, /datum/language/audible_action, new)

/**
 * The language used when someone does an audible emote / there is a hearable narration
 */
/datum/language/audible_action
	id = LANGUAGE_ID_AUDIBLE_ACTION
	name = "Noise"
	desc = "Noises"
	key = ""
	language_flags = LANGUAGE_RESTRICTED|LANGUAGE_NONGLOBAL|LANGUAGE_EVERYONE|LANGUAGE_NO_TALK_MSG|LANGUAGE_NO_STUTTER

/datum/language/audible_action/format_message(message, verb)
	return "<span class='message'><span class='[colour]'>[message]</span></span>"

/datum/language/audible_action/format_message_plain(message, verb)
	return message

/datum/language/audible_action/format_message_radio(message, verb)
	return "<span class='[colour]'>[message]</span>"

/datum/language/audible_action/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2

/datum/language/audible_action/can_speak_special(var/mob/speaker)
	return TRUE	//Audible emotes
