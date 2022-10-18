/datum/category_item/player_setup_item/background/religion
	save_key = CHARACTER_DATA_RELIGION
	sort_order = 6

/datum/category_item/player_setup_item/background/religion/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/datum/lore/character_background/religion/available = SScharacters.available_religions(prefs.character_species_id())
	var/datum/lore/character_background/religion/current = SScharacters.resolve_religion(data)
	. += "<center>"
	for(var/datum/lore/character_background/religion/O in available)
		. += href_simple(prefs, "pick", "[O.name] ", O.id)
	. += "</center>"
	. += "<div>"
	. += current? current.desc : "<center>error; religion load failed</center>"
	. += "</div>"

#warn scroll selector

/datum/category_item/player_setup_item/background/religion/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("pick")
			var/id = params["pick"]
			var/datum/lore/character_background/religion/O = SScharacters.resolve_religion(id)
			if(!id)
				return
			if(!O.check_species_id(prefs.character_species_id()))
				to_chat(user, SPAN_WARNING("[prefs.character_species_name()] cannot pick this religion."))
				return PREFERENCES_NOACTION
			write(prefs, id)
			return PREFERENCES_REFRESH_UPDATE_PREVIEW
	return ..()

/datum/category_item/player_setup_item/background/religion/filter(datum/preferences/prefs, data, list/errors)
	var/datum/lore/character_background/religion/current = SScharacters.resolve_religion(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		return SScharacters.resolve_religion(/datum/lore/character_background/religion/custom).id
	return data

/datum/category_item/player_setup_item/background/religion/copy_to_mob(mob/M, data, flags)
	#warn impl

/datum/category_item/player_setup_item/background/religion/spawn_checks(datum/preferences/prefs, data, flags, list/errors)
	var/datum/lore/character_background/religion/current = SScharacters.resolve_religion(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		errors?.Add("Invalid religion for your current species.")
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/religion/default_value(randomizing)
	return SScharacters.resolve_religion(/datum/lore/character_background/religion/custom).id

/datum/category_item/player_setup_item/background/religion/informed_default_value(datum/preferences/prefs, randomizing)
	var/datum/character_species/S = SScharacters.resolve_character_species(prefs.character_species_id())
	if(!S)
		return ..()
	return S.get_default_religion_id()

/datum/preferences/proc/lore_religion_id()
	return get_character_data(CHARACTER_DATA_RELIGION)

/datum/preferences/proc/lore_religion_datum()
	return SScharacters.resolve_faction(lore_religion_id())
