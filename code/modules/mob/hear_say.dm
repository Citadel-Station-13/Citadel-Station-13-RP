// At minimum every mob has a hear_say proc.
#warn below
/mob/proc/hear_say(raw_message, message, name, voice_ident, atom/actor, remote, list/params, datum/language/lang, list/spans, say_verb)
	#warn below

	if(IS_ALIVE_BUT_UNCONSCIOUS(src))
		hear_sleep(message)
		return

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.language_flags & LANGUAGE_NONVERBAL))
		if (!speaker || (src.sdisabilities & SDISABILITY_NERVOUS || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	var/track = null
	if(istype(src, /mob/observer/dead))
		if(speaker_name != speaker.real_name && speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "([ghost_follow_link(speaker, src)]) "
		if(is_preference_enabled(/datum/client_preference/ghost_ears) && (speaker in view(src)))
			message = "<b>[message]</b>"

	if(is_deaf())
		if(!language || !(language.language_flags & LANGUAGE_EVERYONE)) // LANGUAGE_EVERYONE is the flag for audible-emote-language, so we don't want to show an "x talks but you cannot hear them" message if it's set
			if(speaker == src)
				to_chat(src, "<span class='warning'>You cannot hear yourself speak!</span>")
			else
				to_chat(src, "<span class='name'>[speaker_name]</span>[alt_name] talks but you cannot hear.")
	else
		var/message_to_send = null
		if(language)
			//Hivemind languages already say their names. Also, no indicator if you don't know the language.
			if(client && !(language.language_flags & LANGUAGE_HIVEMIND) && say_understands(speaker, language) && language.shorthand && client.is_preference_enabled(/datum/client_preference/language_indicator))
				verb += " ([language.shorthand])"
			message_to_send = "<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [track][language.format_message(message, verb)]</span>"
		else
			message_to_send = "<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [track][verb], <span class='message'><span class='body'>\"[message]\"</span></span></span>"
		if(check_mentioned(message) && is_preference_enabled(/datum/client_preference/check_mention))
			message_to_send = "<font size='3'><b>[message_to_send]</b></font>"


		on_hear_say(message_to_send)

		if (speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker.z))
			var/turf/source = speaker? get_turf(speaker) : get_turf(src)
			src.playsound_local(source, speech_sound, sound_vol, 1)

/mob/proc/on_hear_say(var/message)
	to_chat(src, message)
	if(teleop)
		to_chat(teleop, create_text_tag("body", "BODY:", teleop) + "[message]")

/mob/living/silicon/on_hear_say(var/message)
	var/time = say_timestamp()
	to_chat(src, "[time] [message]")
	if(teleop)
		to_chat(teleop, create_text_tag("body", "BODY:", teleop) + "[time] [message]")

// Checks if the mob's own name is included inside message.  Handles both first and last names.
/mob/proc/check_mentioned(var/message)
	var/not_included = list("a", "the", "of", "in", "for", "through", "throughout", "therefore", "here", "there", "then", "now", "I", "you", "they", "he", "she", "by")
	var/list/valid_names = splittext_char(real_name, " ") // Should output list("John", "Doe") as an example.
	valid_names -= not_included
	var/list/nicknames = splittext_char(nickname, " ")
	valid_names += nicknames
	valid_names += special_mentions()
	for(var/name in valid_names)
		if(findtext_char(message, regex("\\b[REGEX_QUOTE(name)]\\b", "i"))) // This is to stop 'ai' from triggering if someone says 'wait'.
			return TRUE
	return FALSE

// Override this if you want something besides the mob's name to count for being mentioned in check_mentioned().
/mob/proc/special_mentions()
	return list()

/mob/living/silicon/ai/special_mentions()
	return list("AI") // AI door!

/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")

	if(!client)
		return

	//if it has been more than 0.5 seconds since the last time we heard this, we hear it again
	if(last_radio_sound + 0.5 SECONDS < world.time && src != speaker)
		playsound(loc, 'sound/effects/radiochatter.ogg', 10, 0, -1, falloff = -3)
		last_radio_sound = world.time

	if(IS_ALIVE_BUT_UNCONSCIOUS(src)) //If unconscious or sleeping
		hear_sleep(message)
		return

	var/track = null

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.language_flags & LANGUAGE_NONVERBAL))
		if (!speaker || (src.sdisabilities & SDISABILITY_NERVOUS || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!(language && (language.language_flags & LANGUAGE_EVERYONE))) // skip understanding checks for LANGUAGE_EVERYONE languages
		if(!say_understands(speaker,language))
			if(language)
				message = language_scramble(language, message)
			else
				message = stars(message)

		if(hard_to_hear)
			message = stars(message)

	var/speaker_name = speaker.name

	if(vname)
		speaker_name = vname

	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice

	if(hard_to_hear)
		speaker_name = "unknown"

	var/changed_voice

	if(istype(src, /mob/living/silicon/ai) && !hard_to_hear)
		var/jobname // the mob's "job"
		var/mob/living/carbon/human/impersonating //The crew member being impersonated, if any.

		if (ishuman(speaker))
			var/mob/living/carbon/human/H = speaker

			if(H.wear_mask && istype(H.wear_mask,/obj/item/clothing/mask/gas/voice))
				changed_voice = 1
				var/list/impersonated = new()
				var/mob/living/carbon/human/I = impersonated[speaker_name]

				if(!I)
					for(var/mob/living/carbon/human/M in GLOB.mob_list)
						if(M.real_name == speaker_name)
							I = M
							impersonated[speaker_name] = I
							break

				// If I's display name is currently different from the voice name and using an agent ID then don't impersonate
				// as this would allow the AI to track I and realize the mismatch.
				if(I && !(I.name != speaker_name && I.wear_id && istype(I.wear_id,/obj/item/card/id/syndicate)))
					impersonating = I
					jobname = impersonating.get_assignment()
				else
					jobname = "Unknown"
			else
				jobname = H.get_assignment()

		else if (iscarbon(speaker)) // Nonhuman carbon mob
			jobname = "No id"
		else if (isAI(speaker))
			jobname = "AI"
		else if (isrobot(speaker))
			jobname = "Cyborg"
		else if (istype(speaker, /mob/living/silicon/pai))
			jobname = "Personal AI"
		else
			jobname = "Unknown"

		if(changed_voice)
			if(impersonating)
				track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[impersonating]'>[speaker_name] ([jobname])</a>"
			else
				track = "[speaker_name] ([jobname])"
		else
			track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[speaker]'>[speaker_name] ([jobname])</a>"

	if(istype(src, /mob/observer/dead))
		if(speaker_name != speaker.real_name && !isAI(speaker)) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[speaker_name] ([ghost_follow_link(speaker, src)])"

	message = saycode_emphasis(message)

	var/formatted
	if(language)
		if(client && !(language.language_flags & LANGUAGE_HIVEMIND) && say_understands(speaker, language) && language.shorthand && client.is_preference_enabled(/datum/client_preference/language_indicator))
			verb += " ([language.shorthand])"
		formatted = "[language.format_message_radio(message, verb)][part_c]"
	else
		formatted = "[verb], <span class=\"body\">\"[message]\"</span>[part_c]"


	if((sdisabilities & SDISABILITY_DEAF) || ear_deaf)
		if(prob(20))
			to_chat(src, "<span class='warning'>You feel your headset vibrate but can hear nothing from it!</span>")
	else
		on_hear_radio(part_a, speaker_name, track, part_b, formatted)

/proc/say_timestamp()
	return "<span class='say_quote'>\[[stationtime2text()]\]</span>"

/mob/proc/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/final_message = "[part_a][speaker_name][part_b][formatted]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "<font size='3'><b>[final_message]</b></font>"
	to_chat(src, final_message)

/mob/observer/dead/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/final_message = "[part_a][track][part_b][formatted]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "<font size='3'><b>[final_message]</b></font>"
	to_chat(src, final_message)

/mob/living/silicon/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/time = say_timestamp()
	var/final_message = "[part_a][speaker_name][part_b][formatted]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "[time]<font size='3'><b>[final_message]</b></font>"
	else
		final_message = "[time][final_message]"
	to_chat(src, final_message)

/mob/living/silicon/ai/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/time = say_timestamp()
	var/final_message = "[part_a][track][part_b][formatted]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "[time]<font size='3'><b>[final_message]</b></font>"
	else
		final_message = "[time][final_message]"
	to_chat(src, final_message)

/mob/proc/hear_signlang(var/message, var/verb = "gestures", var/datum/language/language, var/mob/speaker = null)
	if(!client)
		return

	if(say_understands(speaker, language))
		message = "<B>[speaker]</B> [verb], \"[message]\""
	else
		var/adverb
		var/length = length_char(message) * pick(0.8, 0.9, 1.0, 1.1, 1.2)	//Adds a little bit of fuzziness
		switch(length)
			if(0 to 12)		adverb = " briefly"
			if(12 to 30)	adverb = " a short message"
			if(30 to 48)	adverb = " a message"
			if(48 to 90)	adverb = " a lengthy message"
			else			adverb = " a very lengthy message"
		message = "<B>[speaker]</B> [verb][adverb]."

	show_message(message, type = 1) // Type 1 is visual message

/mob/proc/hear_sleep(var/message)
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext_char(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext_char(heardword,1, 1) in punctuation)
			heardword = copytext_char(heardword,2)
		if(copytext_char(heardword,-1) in punctuation)
			heardword = copytext_char(heardword,1,length_char(heardword))
		heard = "<span class = 'game_say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	to_chat(src, heard)
