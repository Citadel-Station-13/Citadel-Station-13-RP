/datum/category_item/player_setup_item/background/origin
	name = "Origin"
	save_key = CHARACTER_DATA_ORIGIN
	sort_order = 2

/datum/category_item/player_setup_item/background/origin/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/datum/lore/character_background/origin/available = SScharacters.available_origins(prefs.character_species_id())
	var/list/categories = list()
	for(var/datum/lore/character_background/origin/O as anything in available)
		LAZYADD(categories[O.category], O)
	var/datum/lore/character_background/origin/current = SScharacters.resolve_origin(data)
	. += "<center>"
	. += "<b>Origin</b><br>"
	for(var/category in categories)
		. += (category == current.category)? "<span class='linkOn'>[category]</span> " : href_simple(prefs, "category", "[category]", category)
		. += " "
	. += "<br>"
	for(var/datum/lore/character_background/origin/O in categories[current.category])
		if(O == current)
			. += "<span class='linkOn'>[O.name]</span>"
		else
			. += href_simple(prefs, "pick", "[O.name]", O.id)
		. += " "
	. += "</center>"
	. += "<div class='statusDisplay'>"
	. += current? current.desc : "<center>error; origin load failed</center>"
	. += "</div>"

/datum/category_item/player_setup_item/background/origin/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("pick")
			var/id = params["pick"]
			var/datum/lore/character_background/origin/O = SScharacters.resolve_origin(id)
			if(!id)
				return
			if(!O.check_species_id(prefs.character_species_id()))
				to_chat(user, SPAN_WARNING("[prefs.character_species_name()] cannot pick this origin."))
				return PREFERENCES_NOACTION
			write(prefs, id)
			return PREFERENCES_REFRESH
		if("category")
			var/cat = params["category"]
			var/list/datum/lore/character_background/origin/origins = SScharacters.available_origins(prefs.character_species_id(), cat)
			if(!length(origins))
				to_chat(user, SPAN_WARNING("No origins in that category have been found; this might be an error."))
				return PREFERENCES_NOACTION
			var/datum/lore/character_background/origin/first = origins[1]
			write(prefs, first.id)
			prefs.sanitize_background_lore()	// update
			return PREFERENCES_REFRESH
	return ..()

/datum/category_item/player_setup_item/background/origin/filter_data(datum/preferences/prefs, data, list/errors)
	var/datum/lore/character_background/origin/current = SScharacters.resolve_origin(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		return SScharacters.resolve_religion(/datum/lore/character_background/origin/custom).id
	return data

/datum/category_item/player_setup_item/background/origin/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: sources - this one is from culture/bcakground
	var/datum/lore/character_background/B = SScharacters.resolve_origin(data)
	for(var/id in B.innate_languages)
		M.add_language(id)
	return TRUE

/datum/category_item/player_setup_item/background/origin/spawn_checks(datum/preferences/prefs, data, flags, list/errors)
	var/datum/lore/character_background/origin/current = SScharacters.resolve_origin(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		errors?.Add("Invalid origin for your current species.")
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/origin/default_value(randomizing)
	return SScharacters.resolve_religion(/datum/lore/character_background/origin/custom).id

/datum/category_item/player_setup_item/background/origin/informed_default_value(datum/preferences/prefs, randomizing)
	var/datum/character_species/S = SScharacters.resolve_character_species(prefs.character_species_id())
	if(!S)
		return ..()
	return S.get_default_origin_id()

/datum/preferences/proc/lore_origin_id()
	return get_character_data(CHARACTER_DATA_ORIGIN)

/datum/preferences/proc/lore_origin_datum()
	return SScharacters.resolve_origin(lore_origin_id())
