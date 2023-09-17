/datum/lore
	/// abstract type
	abstract_type = /datum/lore

/datum/lore/character_background
	abstract_type = /datum/lore/character_background

	/// name
	var/name = "Unknown"
	/// id - **must be unique on subtypes**, use CamelCase
	var/id
	/// category
	var/category = "Misc"
	/// description/what the player sees
	var/desc = "What is this?"
	/// subspecies are counted as the master species
	var/subspecies_included = TRUE
	/// allowed species ids - if is list, only these species can have them; these are character species uids, not normal species ids, subspecies do count; typepaths are allowed
	var/list/allow_species
	/// forbidden species ids - overridden by allowed; typepaths are allowed, will be converted to uids
	var/list/forbid_species
	/// languages that someone gets by picking this; typepaths are allowed, will be converted to uids
	var/list/innate_languages
	/// modify max custom language amount
	var/language_amount_mod = 0
	/// economic background modifier for starting pay
	var/economy_payscale = 1

/datum/lore/character_background/New()
	// resolve typepaths
	if(allow_species && !islist(allow_species))
		CRASH("innate languages not a list; fix your shit.")
	for(var/thing in allow_species)
		if(ispath(thing))
			var/resolved
			if(ispath(thing, /datum/species))
				var/datum/species/access = thing
				resolved = initial(access.uid)
			else if(ispath(thing, /datum/character_species))
				var/datum/character_species/access = thing
				resolved = initial(access.uid)
			allow_species -= thing
			allow_species += resolved
		else if(istext(thing))
			ASSERT(!!SScharacters.resolve_character_species(thing))
		else
			CRASH("you didn't put a valid path or text; fix your shit.")
	if(forbid_species && !islist(forbid_species))
		CRASH("innate languages not a list; fix your shit.")
	for(var/thing in forbid_species)
		if(ispath(thing))
			var/resolved
			if(ispath(thing, /datum/species))
				var/datum/species/access = thing
				resolved = initial(access.uid)
			else if(ispath(thing, /datum/character_species))
				var/datum/character_species/access = thing
				resolved = initial(access.uid)
			allow_species -= thing
			allow_species += resolved
		else if(istext(thing))
			ASSERT(!!SScharacters.resolve_character_species(thing))
		else
			CRASH("you didn't put a valid path or text; fix your shit.")
	if(innate_languages && !islist(innate_languages))
		CRASH("innate languages not a list; fix your shit.")
	for(var/thing in innate_languages)
		if(ispath(thing))
			innate_languages += SScharacters.resolve_language_path(thing).id
			innate_languages -= thing
		else if(istext(thing))
			ASSERT(!!SScharacters.resolve_language_id(thing))
		else
			CRASH("you didn't put a valid path or text; fix your shit.")

/**
 * id passed in is for a /datum/character_species, NOT a /datum/speices!
 */
/datum/lore/character_background/proc/check_species_id(id)
	return check_character_species(SScharacters.resolve_character_species(id))

/datum/lore/character_background/proc/check_character_species(datum/character_species/S)
	if(allow_species)
		return (S.uid in allow_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in allow_species))
	else if(forbid_species)
		return !((S.uid in forbid_species) || (subspecies_included && S.is_subspecies && (S.superspecies_id in forbid_species)))
	return TRUE

/datum/lore/character_background/proc/get_default_language_ids()
	return innate_languages.Copy()
