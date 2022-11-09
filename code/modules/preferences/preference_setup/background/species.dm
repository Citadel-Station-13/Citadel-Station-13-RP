/datum/category_item/player_setup_item/background/char_species
	name = "Character Species"
	sort_order = 1
	save_key = CHARACTER_DATA_CHAR_SPECIES
	load_order = PREFERENCE_LOAD_ORDER_CHAR_SPECIES
	// todo: proper view-only section support

/datum/category_item/player_setup_item/background/char_species/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/datum/character_species/S = prefs.character_species_datum()
	. += "<center>"
	. += "<b>Species</b><br>[S.name] - \[[href_simple(prefs, "change", "CHANGE")]\]"
	. += "</center>"
	. += "<div class='statusDisplay'>"
	. += "[S.desc]"
	. += "</div>"

/datum/category_item/player_setup_item/background/char_species/spawn_checks(datum/preferences/prefs, data, flags, list/errors)
	var/datum/character_species/CS = SScharacters.resolve_character_species(data)
	if(CS.whitelisted && !config.check_alien_whitelist(ckey(CS.name), prefs.client_ckey))
		errors?.Add(SPAN_WARNING("[CS.name] is a whitelisted species!"))
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/char_species/filter_data(datum/preferences/prefs, data, list/errors)
	// resolve
	var/datum/character_species/CS = SScharacters.resolve_character_species(data)
	if(CS)
		// cool we found it
		// but also, make sure we don't, for some reason, mismatch real species
		var/real_id = prefs.get_character_data(CHARACTER_DATA_REAL_SPECIES)
		var/datum/species/check_type = CS.real_species_type
		if(!check_type || (real_id != initial(check_type.uid)))
			// oh no :(
			// default to real species type if possible, don't if not
			return check_type? initial(check_type.uid) : informed_default_value(prefs)
		return data
	return informed_default_value(prefs)

/datum/category_item/player_setup_item/background/char_species/informed_default_value(datum/preferences/prefs, randomizing)
	// do they have a valid real species we can use?
	var/real_id = prefs.get_character_data(CHARACTER_DATA_REAL_SPECIES)
	var/datum/character_species/CS = SScharacters.resolve_character_species(real_id)
	if(CS)
		return real_id
	// no :(
	return default_value()

/datum/category_item/player_setup_item/background/char_species/default_value(randomizing)
	return SScharacters.default_species_id()

/datum/category_item/player_setup_item/background/char_species/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("change")
			prefs.species_pick(user)
			return PREFERENCES_HANDLED
	return ..()

// todo: proper view-only section support
/datum/category_item/player_setup_item/background/real_species
	name = "(Virtual) Real Species"
	sort_order = 2
	save_key = CHARACTER_DATA_REAL_SPECIES
	load_order = PREFERENCE_LOAD_ORDER_REAL_SPECIES

/datum/category_item/player_setup_item/background/real_species/filter_data(datum/preferences/prefs, data, list/errors)
	var/datum/species/S = SScharacters.resolve_species_id(data)
	if(!S)
		return SScharacters.default_species_id()
	if(!(S.name in SScharacters.playable_species))
		return SScharacters.default_species_id()
	return data

/datum/category_item/player_setup_item/background/real_species/default_value(randomizing)
	return SScharacters.default_species_id()

/datum/category_item/player_setup_item/background/real_species/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/H = M
	// we construct character species
	H.set_species(SScharacters.construct_character_species(prefs.get_character_data(CHARACTER_DATA_CHAR_SPECIES)))

/datum/preferences/proc/real_species_id()
	return get_character_data(CHARACTER_DATA_REAL_SPECIES)

/datum/preferences/proc/character_species_id()
	return get_character_data(CHARACTER_DATA_CHAR_SPECIES)

/datum/preferences/proc/character_species_datum()
	RETURN_TYPE(/datum/character_species)
	return SScharacters.resolve_character_species(get_character_data(CHARACTER_DATA_CHAR_SPECIES))

/datum/preferences/proc/character_species_name()
	return SScharacters.resolve_character_species(get_character_data(CHARACTER_DATA_CHAR_SPECIES))?.name || "ERROR"

/datum/preferences/proc/real_species_datum()
	RETURN_TYPE(/datum/species)
	return SScharacters.resolve_species_id(get_character_data(CHARACTER_DATA_REAL_SPECIES))

/datum/preferences/proc/real_species_name()
	return SScharacters.resolve_species_id(get_character_data(CHARACTER_DATA_REAL_SPECIES)).name

/datum/preferences/proc/character_species_job_check(datum/job/J)
	return TRUE	// todo
