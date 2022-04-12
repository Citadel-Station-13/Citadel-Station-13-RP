/datum/lore_info/culture/hidden
	description = "This is a hidden cultural detail. If you can see this, please report it on the tracker."
	hidden = TRUE

/datum/lore_info/culture/hidden/alium
	name = CULTURE_ALIUM
	language = LANGUAGE_ALIUM
	secondary_langs = null

/datum/lore_info/culture/hidden/shadow
	name = CULTURE_STARLIGHT
	language = LANGUAGE_GALCOM
	optional_languages = list(LANGUAGE_CULT,LANGUAGE_OCCULT)

/datum/lore_info/culture/hidden/cultist
	name = CULTURE_CULTIST

/datum/lore_info/culture/hidden/cultist/get_random_name()
	return "[pick("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged")] [pick("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Spook", "Visitant", "Wraith")]"

/datum/lore_info/culture/hidden/monkey
	name = CULTURE_MONKEY
	language = "Chimpanzee"

/datum/lore_info/culture/hidden/monkey/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

/datum/lore_info/culture/hidden/monkey/farwa
	name = CULTURE_FARWA

/datum/lore_info/culture/hidden/monkey/neara
	name = CULTURE_NEARA

/datum/lore_info/culture/hidden/monkey/stok
	name = CULTURE_STOK
