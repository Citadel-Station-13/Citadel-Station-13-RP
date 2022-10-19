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

/datum/lore/character_background/New()
	// resolve typepaths
	for(var/thing in allow_species)
		if(ispath(thing))
			allow_species += SScharacters.resolve_species_path(thing)
			allow_species -= thing
	for(var/thing in forbid_species)
		if(ispath(thing))
			forbid_species += SScharacters.resolve_species_path(thing)
			forbid_species -= thing
	for(var/thing in innate_languages)
		if(ispath(thing))
			innate_languages += SScharacters.resolve_language_path(thing)
			innate_languages -= thing

/datum/lore/character_background/proc/check_species_id(id)
	if(allow_species)
		return id in allow_species
	else if(forbid_species)
		return !(id in forbid_species)
	return TRUE

/datum/lore/character_background/proc/get_default_language_ids()
	return innate_languages.Copy()
