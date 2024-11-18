/mob/proc/say_legacy(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/whispering = 0)
	return

/mob/proc/whisper_wrapper()
	var/message = input("","whisper (text)") as text|null
	if(message)
		whisper(message)

/mob/proc/subtle_wrapper()
	var/message = input("","subtle (text)") as message|null
	if(message)
		me_verb_subtle(message)

/mob/proc/subtler_wrapper()
	var/message = input("","subtler (text)") as message|null
	if(message)
		subtler_anti_ghost(message)

/mob/verb/whisper(message as text)
	set name = "Whisper"
	set category = VERB_CATEGORY_IC

	usr.say_legacy(message,whispering=1)

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = VERB_CATEGORY_IC

	set_typing_indicator(FALSE)
	usr.say_legacy(message)

/mob/verb/me_verb(message as message)
	set name = "Me"
	set category = VERB_CATEGORY_IC

	if(muffled)
		return me_verb_subtle(message)
	message = sanitize_or_reflect(message,src) // Reflect too-long messages (within reason)

	set_typing_indicator(FALSE)
	if(use_me)
		usr.emote("me",SAYCODE_TYPE_ALWAYS,message)
	else
		usr.emote(message)

/mob/proc/say_dead(var/message)
	if(!client)
		return // Clientless mobs shouldn't be trying to talk in deadchat.

	if(!src.client.holder)
		if(!config_legacy.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return

	if(!get_preference_toggle(/datum/game_preference_toggle/chat/dsay))
		to_chat(src, "<span class='danger'>You have deadchat muted.</span>")
		return

	if(is_role_banned_ckey(ckey, role = BAN_ROLE_OOC))
		to_chat(src, SPAN_WARNING("You are banned from OOC and deadchat."))
		return

	message = emoji_parse(say_emphasis(message))

	if(client.persistent.ligma)
		to_chat(src, "<span class='deadsay'><b>DEAD:</b> [src]([ghost_follow_link(src, src)]) [pick("complains","moans","whines","laments","blubbers")], [message]</span>")
		log_shadowban("[key_name(src)] DSAY: [message]")
		return

	say_dead_direct("[pick("complains","moans","whines","laments","blubbers")], <span class='message'>\"<span class='linkify'>[message]</span>\"</span>", src)

/mob/proc/say_understands(var/mob/other,var/datum/language/speaking = null)

	if (src.stat == DEAD)
		return 1

	//Universal speak makes everything understandable, for obvious reasons.
	else if(src.universal_speak || src.universal_understand)
		return 1

	//Languages are handled after.
	if (!speaking)
		if(!other)
			return 1
		if(other.universal_speak)
			return 1
		if(isAI(src) && ispAI(other))
			return 1
		if (istype(other, src.type) || istype(src, other.type))
			return 1
		return 0

	if(speaking.language_flags & LANGUAGE_INNATE)
		return 1

	//Language check.
	for(var/datum/language/L in src.languages)
		if(speaking.name == L.name)
			return 1

	return 0

/*
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is no language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/proc/emote(var/act, var/type, var/message)
	if(act == "me")
		return custom_emote(type, message)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/proc/say_test(var/text)
	var/ending = copytext_char(text, length_char(text))
	if(ending == "?")
		return "1"
	else if(ending == "!")
		return "2"
	return "0"
