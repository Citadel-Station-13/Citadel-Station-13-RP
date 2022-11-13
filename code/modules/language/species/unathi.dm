/datum/language/unathi
	id = LANGUAGE_ID_UNATHI
	name = LANGUAGE_UNATHI
	desc = "The common language of the Moghes Hegemony, composed of sibilant hisses and rattles. Spoken natively by Unathi."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "roars"
	colour = "soghun"
	key = "o"
	space_chance = 40
	syllables = list(
		"za", "az", "ze", "ez", "zi", "iz", "zo", "oz", "zu", "uz", "zs", "sz",
 		"ha", "ah", "he", "eh", "hi", "ih", "ho", "oh", "hu", "uh", "hs", "sh",
 		"la", "al", "le", "el", "li", "il", "lo", "ol", "lu", "ul", "ls", "sl",
 		"ka", "ak", "ke", "ek", "ki", "ik", "ko", "ok", "ku", "uk", "ks", "sk",
 		"sa", "as", "se", "es", "si", "is", "so", "os", "su", "us", "ss", "ss",
 		"ra", "ar", "re", "er", "ri", "ir", "ro", "or", "ru", "ur", "rs", "sr",
 		"a",  "a",  "e",  "e",  "i",  "i",  "o",  "o",  "u",  "u",  "s",  "s"
	)

/datum/language/unathi/get_random_name()

	var/new_name = ..()
	while(findtextEx(new_name,"sss",1,null))
		new_name = replacetext(new_name, "sss", "ss")
	return capitalize(new_name)

