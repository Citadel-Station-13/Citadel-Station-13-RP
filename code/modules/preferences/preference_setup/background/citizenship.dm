/datum/category_item/player_setup_item/background/citizenship
	name = "Citizenship"
	save_key = CHARACTER_DATA_CITIZENSHIP
	sort_order = 3

/datum/category_item/player_setup_item/background/citizenship/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/datum/lore/character_background/citizenship/available = SScharacters.available_citizenships(prefs.character_species_id())
	var/datum/lore/character_background/citizenship/current = SScharacters.resolve_citizenship(data)
	. += "<center>"
	. += "<b>Citizenship</b><br>"
	for(var/datum/lore/character_background/citizenship/O in available)
		if(O == current)
			. += "<span class='linkOn'>[O.name]</span>"
		else
			. += href_simple(prefs, "pick", "[O.name]", O.id)
		. += " "
	. += "</center>"
	. += "<div class='statusDisplay'>"
	. += current? current.desc : "<center>error; citizenship load failed</center>"
	. += "</div>"

/datum/category_item/player_setup_item/background/citizenship/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("pick")
			var/id = params["pick"]
			var/datum/lore/character_background/citizenship/O = SScharacters.resolve_citizenship(id)
			if(!id)
				return
			if(!O.check_species_id(prefs.character_species_id()))
				to_chat(user, SPAN_WARNING("[prefs.character_species_name()] cannot pick this citizenship."))
				return PREFERENCES_NOACTION
			write(prefs, id)
			prefs.sanitize_background_lore()	// update
			return PREFERENCES_REFRESH
	return ..()

/datum/category_item/player_setup_item/background/citizenship/filter_data(datum/preferences/prefs, data, list/errors)
	var/datum/lore/character_background/citizenship/current = SScharacters.resolve_citizenship(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		return SScharacters.resolve_citizenship(/datum/lore/character_background/citizenship/custom).id
	return data

/datum/category_item/player_setup_item/background/citizenship/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: sources - this one is from culture/bcakground
	var/datum/lore/character_background/B = SScharacters.resolve_citizenship(data)
	for(var/id in B.innate_languages)
		M.add_language(id)
	return TRUE

/datum/category_item/player_setup_item/background/citizenship/spawn_checks(datum/preferences/prefs, data, flags, list/errors)
	var/datum/lore/character_background/citizenship/current = SScharacters.resolve_citizenship(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		errors?.Add("Invalid citizenship for your current species.")
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/citizenship/default_value(randomizing)
	return SScharacters.resolve_citizenship(/datum/lore/character_background/citizenship/custom).id

/datum/category_item/player_setup_item/background/citizenship/informed_default_value(datum/preferences/prefs, randomizing)
	var/datum/character_species/S = SScharacters.resolve_character_species(prefs.character_species_id())
	if(!S)
		return ..()
	return S.get_default_citizenship_id()

/datum/preferences/proc/lore_citizenship_id()
	return get_character_data(CHARACTER_DATA_CITIZENSHIP)

/datum/preferences/proc/lore_citizenship_datum()
	return SScharacters.resolve_citizenship(lore_citizenship_id())
