/datum/language/skrell
	id = LANGAUGE_ID_SKRELL
	name = LANGUAGE_SKRELLIAN
	desc = "A set of warbles and hums, the language itself a complex mesh of both melodic and rhythmic components, exceptionally capable of conveying intent and emotion of the speaker."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "sings"
	whisper_verb = "hums"
	colour = "skrell"
	key = "k"
	space_chance = 30
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix")


/datum/language/skrellfar
	id = LANGUAGE_ID_SKRELL_ALT
	name = LANGUAGE_SKRELLIANFAR
	desc = "The most common language among the Skrellian Far Kingdoms. Has an even higher than usual concentration of inaudible phonemes."
	speech_verb = "warbles"
	ask_verb = "warbles"
	exclaim_verb = "sings"
	whisper_verb = "hums"
	colour = "skrellfar"
	key = "p"
	space_chance = 30
	flags = WHITELISTED
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix", "...", "oo", "q", "nq", "x", "xq", "ll", "...", "...", "...") //should sound like there's holes in it

/datum/language/skrell/get_random_name(var/gender)
	var/list/first_names = world.file2list('strings/names/first_name_skrell.txt')
	var/list/last_names = world.file2list('strings/names/last_name_skrell.txt')
	return "[pick(first_names)] [pick(last_names)]"
