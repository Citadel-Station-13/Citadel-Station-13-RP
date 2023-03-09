/**
 * shim until saycode rewrite
 */
// todo: refactor this shit to be unified saycode, christ
/atom/proc/atom_say(message, datum/language/L)
	if(!message)
		return
	var/list/speech_bubble_hearers = list()
	var/no_runechat = FALSE
	for(var/mob/M in get_hearers_in_view(MESSAGE_RANGE_COMBAT_LOUD, src))
		var/processed = message
		if(L && !(L.name in M.languages))
			processed = L.scramble(message)
			no_runechat = TRUE
		M.show_message("<span class='game say'><span class='name'>[src]</span> [L?.speech_verb || atom_say_verb], \"[processed]\"</span>", 2, null, 1)
		if(M.client)
			speech_bubble_hearers += M.client

	if(length(speech_bubble_hearers) && !no_runechat)
		var/image/I = generate_speech_bubble(src, "[bubble_icon][say_test(message)]", FLY_LAYER)
		I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
		INVOKE_ASYNC(GLOBAL_PROC, /.proc/flick_overlay, I, speech_bubble_hearers, 30)
		INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, null, FALSE, speech_bubble_hearers, 30)

/atom/proc/say_overhead(var/message, whispering, message_range = 7, var/datum/language/speaking = null, var/list/passed_hearing_list)
	var/list/speech_bubble_hearers = list()
	var/italics
	if(whispering)
		italics = TRUE
	for(var/mob/M in get_mobs_in_view(message_range, src))
		if(M.client)
			speech_bubble_hearers += M.client
	if(length(speech_bubble_hearers))
		INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, speaking, italics, speech_bubble_hearers, 30)

/proc/generate_speech_bubble(var/bubble_loc, var/speech_state, var/set_layer = FLOAT_LAYER)
	var/image/I = image('icons/mob/talk_vr.dmi', bubble_loc, speech_state, set_layer)
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	return I

/atom/proc/speech_bubble(bubble_state = "", bubble_loc = src, list/bubble_recipients = list())
	return
