/datum/category_item/player_setup_item/background/species
	sort_order = 1
	save_key = CHARACTER_DATA_SPECIES
	// todo: proper view-only section support

/datum/category_item/player_setup_item/background/species/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/datum/character_species/S = prefs.character_species_datum()
	. += "<center>"
	. += "Selected species: [S.name]"
	. += "</center>"
	. += "<div>"
	. += "[S.desc]"
	. += "</div>"

#warn main species selector has to use save key

/datum/preferences/proc/character_species_id()
	return get_character_data(CHARACTER_DATA_SPECIES)

/datum/preferences/proc/character_species_datum()
	RETURN_TYPE(/datum/character_species)
	return SScharacters.resolve_character_species(get_character_data(CHARACTER_DATA_SPECIES))

/datum/preferences/proc/character_species_name()
	return SScharacters.resolve_character_species(get_character_data(CHARACTER_DATA_SPECIES))?.name || "ERROR"
