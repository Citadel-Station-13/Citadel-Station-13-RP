/mob/living/silicon/ai/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	..()
	if(message_mode == "department")
		return holopad_talk(message, verb, speaking)
	else if(message_mode)
		if (aiRadio.disabledAi || aiRestorePowerRoutine || stat)
			to_chat(src, "<span class='danger'>System Error - Transceiver Disabled.</span>")
			return 0
		if(message_mode == "general")
			message_mode = null
		return aiRadio.talk_into(src,message,message_mode,verb,speaking)

//For holopads only. Usable by AI.
/mob/living/silicon/ai/proc/holopad_talk(var/message, verb, datum/language/speaking)
	message = trim(message)

	if (!message)
		return

	if(holopad)
		if(!holopad.relay_inbound_say(src, name, message, speaking, using_verb = verb))
			to_chat(src, "Failed to relay to holopad.")
			return FALSE
		to_chat(src, "Holopad voice relayed: [SPAN_NAME(name)]: [message]")
		log_say("(HPAD) [message]", src)
	else //This shouldn't occur, but better safe then sorry.
		to_chat(src, "No holopad connected.")
		return FALSE
	return TRUE

/mob/living/silicon/ai/proc/holopad_emote(var/message) //This is called when the AI uses the 'me' verb while using a holopad.

	message = trim(message)

	if (!message)
		return

	if(holopad)
		if(!holopad.relay_inbound_emote(src, name, message, hologram))
			to_chat(src, "Failed to relay to holopad.")
			return FALSE
		to_chat(src, "Holopad action relayed: [SPAN_NAME(name)] [message]")
		log_emote("(HPAD) [message]", src)
	else //This shouldn't occur, but better safe then sorry.
		to_chat(src, "No holopad connected.")
		return FALSE
	return TRUE

/mob/living/silicon/ai/emote(var/act, var/type, var/message)
	if(holopad)
		holopad_emote(message)
	else //Emote normally, then.
		..()
