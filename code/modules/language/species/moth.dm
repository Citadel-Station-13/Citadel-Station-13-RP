/datum/language/species/moth
#warn impl
	name = LANGUAGE_LUINIMMA
	desc = "The language of the Dnin-Nepids, Luinimma sounds like a quick, tonal series of chitters, chirps, and clicks to \
	non-speakers."
	speech_verb = "chitters"
	ask_verb = "clacks"
	exclaim_verb = "rasps"
	whisper_verb = "clicks"
	signlang_verb = list("")
	colour = "body"
	#warn check key conflict
	key = "m"
	native = TRUE
	flags = NONE
	#warn lmao
	syllables = list(
		"at", "az", "ak", "afz",
		"bv", "bz",
		"ch", "cz", "cih", "chi",
		"di",
		"et", "ez", "ecz", "eht",
		"ft", "fih",
		"h",
		"iz", "it", "ich", "ihz",
		"ki", "ke", "k",
		"l",
		"ok", "ock", "ot",
		"pz", "pt", "pht", "pf", "pft",
		"qr", "qi", "qk",
		"ri", "ra", "re", "ro",
		"st", "sz", "sck", "ss", "sit",
		"ti", "tch", "tk", "tck", "tc", "tz", "thi",
		"vt", "vz",
		"wr",
		"xi", "xt", "xhi", "xct", "xci",
		"z"
	)
	space_chance = 35
	machine_understands = FALSE
	partial_understanding = list()

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
