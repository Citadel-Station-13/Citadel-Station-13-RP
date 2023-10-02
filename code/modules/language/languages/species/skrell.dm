/datum/language/skrell
	id = LANGUAGE_ID_SKRELL
	name = LANGUAGE_SKRELLIAN
	translation_class = TRANSLATION_CLASS_DEFAULT_CORE_RACE
	desc = "A set of warbles and hums, the language itself a complex mesh of both melodic and rhythmic components, exceptionally capable of conveying intent and emotion of the speaker."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "sings"
	whisper_verb = "hums"
	colour = "skrell"
	key = "k"
	space_chance = 30
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix")
	shorthand = "SKRL"


/datum/language/skrellfar
	id = LANGUAGE_ID_SKRELL_ALT
	name = LANGUAGE_SKRELLIANFAR
	translation_class = TRANSLATION_CLASS_DEFAULT_CORE_RACE
	desc = "The most common language among the Skrellian Far Kingdoms. Has an even higher than usual concentration of inaudible phonemes."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "sings"
	whisper_verb = "hums"
	colour = "skrellfar"
	key = "p"
	space_chance = 30
	language_flags = LANGUAGE_WHITELISTED
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix", "...", "oo", "q", "nq", "x", "xq", "ll", "...", "...", "...") //should sound like there's holes in it
	shorthand = "SKRLFR"

/datum/language/skrell/get_random_name(gender)
	var/list/first_name = GLOB.skrell_first_names
	var/list/last_name = GLOB.skrell_last_names
	return "[pick(first_name)] [pick(last_name)]"
