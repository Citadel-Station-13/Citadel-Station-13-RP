// 'basic' language; spoken by default.
/datum/language/common
	id = LANGUAGE_ID_COMMON
	name = LANGUAGE_GALCOM
	desc = "The common galactic tongue, engineered for cross-species communication."
	speech_verb = "says"
	exclaim_verb = list("exclaims","shouts","yells")
	whisper_verb = "whispers"
	key = "0"
	language_flags = RESTRICTED
	syllables = list(
"vol", "zum", "coo","zoo","bi","do","ooz","ite","og","re","si","ite","ish",
"ar","at","on","ee","east","ma","da", "rim")
	partial_understanding = list(LANGUAGE_SKRELLIAN = 30, LANGUAGE_SOL_COMMON = 30)

/datum/language/machine
	id = LANGUAGE_ID_EAL
	name = LANGUAGE_EAL
	desc = "An efficient language of encoded tones developed by positronics."
	speech_verb = "whistles"
	ask_verb = "chirps"
	exclaim_verb = "whistles loudly"
	colour = "changeling"
	key = "6"
	language_flags = NO_STUTTER
	syllables = list("beep","beep","beep","beep","beep","boop","boop","boop","bop","bop","dee","dee","doo","doo","hiss","hss","buzz","buzz","bzz","ksssh","keey","wurr","wahh","tzzz","shh","shk")
	space_chance = 10

/datum/language/machine/get_random_name()
	if(prob(70))
		return "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	else
		return pick(GLOB.ai_names)

/datum/language/sign
	id = LANGUAGE_ID_SIGN
	name = LANGUAGE_SIGN
	desc = "A sign language commonly used for those who are deaf or mute."
	signlang_verb = list("gestures")
	colour = "say_quote"
	key = "s"
	language_flags = SIGNLANG|NO_STUTTER|NONVERBAL

/datum/language/sign/can_speak_special(var/mob/speaker)	// TODO: If ever we make external organs assist languages, convert this over to the new format
	var/obj/item/organ/external/hand/hands = locate() in speaker //you can't sign without hands
	return (hands || !iscarbon(speaker))
