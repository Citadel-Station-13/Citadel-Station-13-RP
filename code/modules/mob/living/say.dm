/mob/living/proc/get_default_language()
	return default_language

//Takes a list of the form list(message, verb, whispering) and modifies it as needed
//Returns 1 if a speech problem was applied, 0 otherwise
/mob/living/proc/handle_speech_problems(var/list/message_data)
	var/message = message_data[1]
	var/verb = message_data[2]
	var/whispering = message_data[3]
	. = 0

	if(HAS_TRAIT(src, silent) || silent)
		. = TRUE
		message_data[1] = ""
		return


	if((MUTATION_HULK in mutations) && health >= 25 && length_char(message))
		message = "[uppertext(message)]!!!"
		verb = pick("yells","roars","hollers")
		whispering = 0
		. = 1
	if(slurring)
		message = slur(message)
		verb = pick("slobbers","slurs")
		. = 1
	if(stuttering)
		message = stutter(message)
		verb = pick("stammers","stutters")
		. = 1
	if(muffled)
		verb = pick("muffles")
		whispering = 1
		. = 1

	message_data[1] = message
	message_data[2] = verb
	message_data[3] = whispering

/mob/living/proc/handle_speech_sound()
	var/list/returns[2]
	returns[1] = null
	returns[2] = null
	return returns

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	var/turf/T = get_turf(src)
	//We're in something, gesture to people inside the same thing
	if(loc != T)
		for(var/mob/M in loc)
			M.hear_signlang(message, verb, language, src)

	//We're on a turf, gesture to visible as if we were a normal language
	else
		var/list/potentials = get_mobs_and_objs_in_view_fast(T, world.view)
		var/list/mobs = potentials["mobs"]
		for(var/hearer in mobs)
			var/mob/M = hearer
			M.hear_signlang(message, verb, language, src)
		var/list/objs = potentials["objs"]
		for(var/hearer in objs)
			var/obj/O = hearer
			O.hear_signlang(src, message, verb, language)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name

/mob/proc/speech_bubble_appearance()
	return "normal"
