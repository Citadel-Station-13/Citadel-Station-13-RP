/datum/language/vox
	id = LANGUAGE_ID_VOX
	name = LANGUAGE_VOX
	translation_class = NONE
	desc = "The common tongue of the various Vox ships making up the Shoal. It sounds like chaotic shrieking to everyone else."
	speech_verb = "shrieks"
	ask_verb = "creels"
	exclaim_verb = "SHRIEKS"
	colour = "vox"
	key = "5"
	language_flags = LANGUAGE_WHITELISTED
	syllables = list("ti","ti","ti","hi","hi","ki","ki","ki","ki","ya","ta","ha","ka","ya","chi","cha","kah", \
	"SKRE","AHK","EHK","RAWK","KRA","AAA","EEE","KI","II","KRI","KA")
	shorthand = "VOX"

/datum/language/vox/get_random_name()
	return ..(FEMALE,1,6)
