/datum/category_item/player_setup_item/background/culture
	name = "Culture"
	save_key = CHARACTER_DATA_CULTURE
	sort_order = 5

/datum/category_item/player_setup_item/background/culture/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/datum/lore/character_background/culture/available = SScharacters.available_cultures(prefs.character_species_id())
	var/list/categories = list()
	var/datum/lore/character_background/culture/current = SScharacters.resolve_culture(data)
	var/current_category
	for(var/datum/lore/character_background/culture/O as anything in available)
		LAZYADD(categories[O.category], O)
		if(O == current)
			current_category = O.category
	. += "<center>"
	. += "<b>Culture</b><br>"
	if(length(categories) > 1)
		for(var/category in categories)
			. += (category == current.category)? "<span class='linkOn'>[category]</span> " : href_simple(prefs, "category", "[category]", category)
			. += " "
		. += "<br>"
	for(var/datum/lore/character_background/culture/O in available)
		if(O == current)
			. += "<span class='linkOn'>[O.name]</span>"
		else if(current_category && O.category != current_category)
			continue
		else
			. += href_simple(prefs, "pick", "[O.name]", O.id)
		. += " "
	. += "</center>"
	. += "<div class='statusDisplay'>"
	. += current? current.desc : "<center>error; culture load failed</center>"
	. += "</div>"

/datum/category_item/player_setup_item/background/culture/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("pick")
			var/id = params["pick"]
			var/datum/lore/character_background/culture/O = SScharacters.resolve_culture(id)
			if(!id)
				return
			if(!O.check_species_id(prefs.character_species_id()))
				to_chat(user, SPAN_WARNING("[prefs.character_species_name()] cannot pick this culture."))
				return PREFERENCES_NOACTION
			write(prefs, id)
			prefs.sanitize_background_lore()	// update
			return PREFERENCES_REFRESH
		if("category")
			var/cat = params["category"]
			var/list/datum/lore/character_background/culture/cultures = SScharacters.available_cultures(prefs.character_species_id(), cat)
			if(!length(cultures))
				to_chat(user, SPAN_WARNING("No cultures in that category have been found; this might be an error."))
				return PREFERENCES_NOACTION
			var/datum/lore/character_background/culture/first = cultures[1]
			write(prefs, first.id)
			prefs.sanitize_background_lore()	// update
			return PREFERENCES_REFRESH
	return ..()

/datum/category_item/player_setup_item/background/culture/filter_data(datum/preferences/prefs, data, list/errors)
	var/datum/lore/character_background/culture/current = SScharacters.resolve_culture(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		return SScharacters.resolve_culture(/datum/lore/character_background/culture/custom).id
	return data

/datum/category_item/player_setup_item/background/culture/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: sources - this one is from culture/bcakground
	var/datum/lore/character_background/B = SScharacters.resolve_culture(data)
	for(var/id in B.innate_languages)
		M.add_language(id)
	return TRUE

/datum/category_item/player_setup_item/background/culture/spawn_checks(datum/preferences/prefs, data, flags, list/errors, list/warnings)
	var/datum/lore/character_background/culture/current = SScharacters.resolve_culture(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		errors?.Add("Invalid culture for your current species.")
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/culture/default_value(randomizing)
	return SScharacters.resolve_culture(/datum/lore/character_background/culture/custom).id

/datum/category_item/player_setup_item/background/culture/informed_default_value(datum/preferences/prefs, randomizing)
	var/datum/character_species/S = SScharacters.resolve_character_species(prefs.character_species_id())
	if(!S)
		return ..()
	return S.get_default_culture_id()

/datum/preferences/proc/lore_culture_id()
	return get_character_data(CHARACTER_DATA_CULTURE)

/datum/preferences/proc/lore_culture_datum()
	RETURN_TYPE(/datum/lore/character_background/culture)
	return SScharacters.resolve_culture(lore_culture_id())
