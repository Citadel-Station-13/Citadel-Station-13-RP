
/**
 * Legacy below
 */

/mob/proc/emote(var/act, var/type, var/message)
	act = trim(act)
	var/spacer = findtext_char(act, " ")
	var/raw_key
	var/raw_params
	if(spacer != 0)
		raw_key = copytext_char(act, 1, spacer + 1)
		raw_params = copytext_char(act, spacer + 1)
	else
		raw_key = act
		raw_params = ""
	var/results = invoke_emote(raw_key, raw_params, new /datum/event_args/actor(src))
	switch(results)
		if(EMOTE_INVOKE_INVALID)
			return
		else
			return "stop"

/// Deprecated.
/mob/proc/visible_emote(var/act_desc)
	run_custom_emote(act_desc, saycode_type = SAYCODE_TYPE_VISIBLE)

/// Deprecated.
/mob/proc/audible_emote(var/act_desc)
	run_custom_emote(act_desc, saycode_type = SAYCODE_TYPE_AUDIBLE)

#warn purge below
// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type=1,var/message = null,var/range=world.view)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(stat)
		to_chat(src, "You are unable to emote.")
		return

	var/muzzled = is_muzzled()
	if(m_type == 2 && muzzled)
		return

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src,"Choose an emote to display.") as text|null, src) // Reflect too long messages, within reason.
	else
		input = message
	if(input)
		log_emote(message,src) //Log before we add junk
		//If the message starts with a comma or apostrophe, no space after the name.
		//We have to account for sanitization so we take the whole first word to see if it's a character code.
		var/nospace = GLOB.valid_starting_punctuation.Find(input)
		message = "<span class='emote'><B>[src]</B>[nospace ? "" : " "][input]</span>"
	else
		return

/mob/proc/emote_dead(var/message)

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src, "Choose an emote to display.") as text|null, src) // Reflect too long messages, within reason
	else
		input = message

	input = emoji_parse(say_emphasis(input))

	if(input)
		log_ghostemote(input, src)
		if(!invisibility) //If the ghost is made visible by admins or cult. And to see if the ghost has toggled its own visibility, as well. -Mech
			visible_message(SPAN_DEADSAY("<B>[src]</B> [input]"))
		else
			say_dead_direct(input, src)
