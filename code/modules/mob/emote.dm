
/**
 * Legacy below
 */

/mob/proc/emote(var/act, var/type, var/message)
	act = trim(act)
	var/spacer = findtext_char(act, " ")
	var/raw_key
	var/raw_params
	if(spacer != 0)
		raw_key = copytext_char(act, 1, spacer)
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

/// Deprecated
/mob/proc/custom_emote(m_type, message)
	switch(m_type)
		if(2)
			audible_emote(message)
		else
			visible_emote(message)
