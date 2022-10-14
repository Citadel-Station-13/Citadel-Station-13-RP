/datum/category_item/player_setup_item/background/origin
	save_key = CHARACTER_DATA_ORIGIN
	sort_order = 2

/datum/category_item/player_setup_item/background/origin/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/datum/lore/character_background/origin/available = SScharacters.available_origins(prefs.character_species_id())
	var/datum/lore/character_background/origin/current = SScharacters.character_origins[data]
	. += "<center>"
	for(var/datum/lore/character_background/origin/O in available)
		. += href_simple(prefs, "pick", "[O.name] ", O.id)
	. += "</center>"
	. += "<div>"
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
			return PREFERENCES_REFRESH_UPDATE_PREVIEW
	return ..()

/datum/category_item/player_setup_item/background/origin/filter(datum/preferences/prefs, data, list/errors)
	var/datum/lore/character_background/origin/current = SScharacters.resolve_origin(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		return SScharacters.resolve_religion(/datum/lore/character_background/origin/custom).id
	return data

/datum/category_item/player_setup_item/background/origin/copy_to_mob(mob/M, data, flags)
	#warn impl

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
	return SScharacters.resolve_faction(lore_origin_id())
