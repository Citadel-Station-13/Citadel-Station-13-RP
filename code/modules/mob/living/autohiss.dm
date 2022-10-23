/mob/living/proc/handle_autohiss(message, datum/language/L)
	return message // no autohiss at this level

/mob/living/carbon/human/handle_autohiss(message, datum/language/L)
	if(!client || autohiss_mode == AUTOHISS_OFF || autohiss_type == AUTOHISS_TYPE_NONE) // no need to process if there's no client or they have autohiss off
		return message

	var/datum/autohiss_maps/maps = autohiss_type_to_datum(autohiss_type)

	if(!maps.basic)
		return message
	if(L.flags & NO_STUTTER)		// Currently prevents EAL, Sign language, and emotes from autohissing
		return message
	if(maps.exempt && (L.name in maps.exempt))
		return message

	var/map = maps.basic.Copy()
	if(autohiss_mode == AUTOHISS_FULL && maps.extra)
		map |= maps.extra

	. = list()

	while(length(message))
		var/min_index = 10000 // if the message is longer than this, the autohiss is the least of your problems
		var/min_char = null
		for(var/char in map)
			var/i = findtext(message, char)
			if(!i) // no more of this character anywhere in the string, don't even bother searching next time
				map -= char
			else if(i < min_index)
				min_index = i
				min_char = char
		if(!min_char) // we didn't find any of the mapping characters
			. += message
			break
		. += copytext(message, 1, min_index)
		if(copytext(message, min_index, min_index+1) == uppertext(min_char))
			switch(text2ascii(message, min_index+1))
				if(65 to 90) // A-Z, uppercase; uppercase R/S followed by another uppercase letter, uppercase the entire replacement string
					. += uppertext(pick(map[min_char]))
				else
					. += capitalize(pick(map[min_char]))
		else
			. += pick(map[min_char])
		message = copytext(message, min_index + 1)

	return jointext(., null)

/mob/living
	var/autohiss_mode = AUTOHISS_OFF
	var/autohiss_type = AUTOHISS_TYPE_NONE

//If you are planning on adding autohiss for a new species, please change autohiss_type_to_datum, toggle_autohiss_type,
//as well as code/modules/client/preference_setup/vore/04_autohiss.dm to add in the new species as well.

/datum/autohiss_maps
	var/list/basic //The things we will replace on basic settings.
	var/list/extra //The things we will replace on full settings, on top of basic.
	var/list/exempt //If we are speaking this language, we will not apply autohiss. (Usually for native languages to a species.)

/datum/autohiss_maps/unathi
	basic = list(
			"s" = list("ss", "sss", "ssss")
		)
	extra = list(
			"x" = list("ks", "kss", "ksss")
		)
	exempt = list(LANGUAGE_UNATHI)

/datum/autohiss_maps/tajaran
	basic = list(
			"r" = list("rr", "rrr", "rrrr")
		)
	exempt = list(LANGUAGE_SIIK,LANGUAGE_AKHANI)

/proc/autohiss_type_to_datum(type)
	RETURN_TYPE(/datum/autohiss_maps)
	switch(type)
		if(AUTOHISS_TYPE_UNATHI)
			return new /datum/autohiss_maps/unathi()
		if(AUTOHISS_TYPE_TAJARAN)
			return new /datum/autohiss_maps/tajaran()
		else
			CRASH("Autohiss could not convert '[type]' to maps!")

/mob/living/carbon/human/verb/toggle_autohiss()
	set name = "Toggle Autohiss"
	set category = "OOC"
	set desc = "Toggle your autohiss configuration between disabled, basic, and full."

	switch(autohiss_mode)
		if(AUTOHISS_OFF)
			autohiss_mode = AUTOHISS_BASIC
			to_chat(src, SPAN_NOTICE("Autohiss changed to basic."))
		if(AUTOHISS_BASIC)
			autohiss_mode = AUTOHISS_FULL
			to_chat(src, SPAN_NOTICE("Autohiss changed to full."))
		if(AUTOHISS_FULL)
			autohiss_mode = AUTOHISS_OFF
			to_chat(src, SPAN_NOTICE("Autohiss disabled."))


/mob/living/carbon/human/verb/toggle_autohiss_type()
	set name = "Toggle Autohiss Type"
	set category = "OOC"
	set desc = "Set the type of autohissing you will do."

	var/new_autohiss_type = input(usr, "Select your new autohiss type.", "Autohiss Type") in list("None", SPECIES_UNATHI, "Tajaran")

	switch(new_autohiss_type)
		if("None")
			autohiss_type = AUTOHISS_TYPE_NONE
			to_chat(src, SPAN_NOTICE("Autohiss disabled."))
		if(SPECIES_UNATHI)
			autohiss_type = AUTOHISS_TYPE_UNATHI
			to_chat(src, SPAN_NOTICE("Autohiss type changed to unathi."))
		if("Tajaran")
			autohiss_type = AUTOHISS_TYPE_TAJARAN
			to_chat(src, SPAN_NOTICE("Autohiss type changed to tajaran."))
