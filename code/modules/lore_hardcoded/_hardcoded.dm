/datum/lore
	/// abstract type
	var/abstract_type = /datum/lore

/datum/lore/character_background
	abstract_type = /datum/lore/character_background
	/// name
	var/name = "Unknown"
	/// id - **must be unique on subtypes
	var/id
	/// description/what the player sees
	var/desc = "What is this?"
	/// subspecies are counted as the master species
	var/subspecies_included = TRUE
	/// allowed species ids - if is list, only these species can have them; these are species uids, not normal species ids, subspecies do count; typepaths are allowed
	var/list/allow_species
	/// forbidden species ids - overridden by allowed; typepaths are lalowed
	var/list/forbid_species
	/// languages that someone gets by picking this; typepaths are allowed
	var/list/innate_languages

	#warn consider allowing typepaths as well as ids for species/language

/datum/lore/character_background/proc/check_species_id(id)
	#warn impl
