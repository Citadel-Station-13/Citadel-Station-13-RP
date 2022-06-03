/datum/language/species/moth
#warn impl
	name = ""
	desc = ""
	speech_verb = ""
	ask_verb = ""
	exclaim_verb = ""
	whisper_verb = ""
	signlang_verb = list("")
	colour = "body"
	key = "m"
	native = TRUE
	flags = NONE
	#warn lmao
	syllables = list(

	)
	space_chance = 55
	machine_understands = FALSE
	partial_understanding = list(

	)

/datum/language/species/moth/get_random_name(gender, name_count = 2, syllable_count= 4 , syllable_divisor = 2)
	#warn maybe don't use this
	if(!syllables || !syllables.len)
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

	var/full_name = ""
	var/new_name = ""

	for(var/i = 0;i<name_count;i++)
		new_name = ""
		for(var/x = rand(FLOOR(syllable_count/syllable_divisor, 1),syllable_count);x>0;x--)
			new_name += pick(syllables)
		full_name += " [capitalize(lowertext(new_name))]"

	return "[trim(full_name)]"
