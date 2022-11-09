/datum/language/species/moth
	id = LANGUAGE_ID_LUINIMMA
	name = LANGUAGE_LUINIMMA
	desc = "The language of the Dnin-Nepids, Luinimma sounds like a quick, tonal series of chitters, chirps, and clicks to \
	non-speakers."
	speech_verb = "chitters"
	ask_verb = "clacks"
	exclaim_verb = "rasps"
	whisper_verb = "clicks"
	signlang_verb = list("")
	colour = "luinimma"
	key = "e"
	native = TRUE
	language_flags = NONE
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
	var/list/names = GLOB.moth_lore_data["name"]
	var/list/occupations = GLOB.moth_lore_data["profession"]
	var/i
	i = rand(1, names.len)
	var/name = capitalize(names[i])
	i = rand(1, occupations.len)
	var/occupation = occupations[i]
	return "[name] [occupation]"
