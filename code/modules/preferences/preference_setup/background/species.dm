/datum/category_item/player_setup_item/background/char_species
	name = "(Virtual) Character Species"
	sort_order = 2
	save_key = CHARACTER_DATA_CHAR_SPECIES
	load_order = PREFERENCE_LOAD_ORDER_CHAR_SPECIES
	// todo: proper view-only section support

/datum/category_item/player_setup_item/background/char_species/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/datum/character_species/S = prefs.character_species_datum()
	. += "<center>"
	. += "Selected species: [S.name]"
	. += "</center>"
	. += "<div>"
	. += "[S.desc]"
	. += "</div>"

/datum/category_item/player_setup_item/background/char_species/filter(datum/preferences/prefs, data, list/errors)
	. = ..()

/datum/category_item/player_setup_item/background/char_species/informed_default_value(datum/preferences/prefs, randomizing)
	. = ..()

/datum/category_item/player_setup_item/background/char_species/default_value(randomizing)
	. = ..()

#warn we DO use this to filter
#warn need another key for character species
#warn main species selector has to use save key

/datum/category_item/player_setup_item/background/real_species
	name = "(Virtual) Real Species"
	sort_order = 1
	save_key = CHARACTER_DATA_REAL_SPECIES
	load_order = PREFERENCE_LOAD_ORDER_REAL_SPECIES
	// todo: proper view-only section support

/datum/category_item/player_setup_item/background/real_species/filter(datum/preferences/prefs, data, list/errors)
	. = ..()

/datum/category_item/player_setup_item/background/real_species/default_value(randomizing)
	. = ..()


/datum/preferences/proc/real_species_id()
	return get_character_data(CHARACTER_DATA_REAL_SPECIES)

/datum/preferences/proc/character_species_id()
	return get_character_data(CHARACTER_DATA_CHAR_SPECIES)

/datum/preferences/proc/character_species_datum()
	RETURN_TYPE(/datum/character_species)
	return SScharacters.resolve_character_species(get_character_data(CHARACTER_DATA_SPECIES))

/datum/preferences/proc/character_species_name()
	return SScharacters.resolve_character_species(get_character_data(CHARACTER_DATA_SPECIES))?.name || "ERROR"
