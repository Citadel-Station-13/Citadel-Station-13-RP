/datum/category_item/player_setup_item/background/faction
	save_key = CHARACTER_DATA_FACTION
	sort_order = 5

/datum/category_item/player_setup_item/background/faction/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/datum/lore/character_background/faction/available = SScharacters.available_factions(prefs.character_species_id())
	var/datum/lore/character_background/faction/current = SScharacters.character_factions[data]
	. += "<center>"
	for(var/datum/lore/character_background/faction/O in available)
		. += href_simple(prefs, "pick", "[O.name] ", O.id)
	. += "</center>"
	. += "<div>"
	. += current? current.desc : "<center>error; faction load failed</center>"
	. += "</div>"

/datum/category_item/player_setup_item/background/faction/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("pick")
			var/id = params["pick"]
			var/datum/lore/character_background/faction/O = SScharacters.resolve_faction(id)
			if(!id)
				return
			if(!O.check_species_id(prefs.character_species_id()))
				to_chat(user, SPAN_WARNING("[prefs.character_species_name()] cannot pick this faction."))
				return PREFERENCES_NOACTION
			write(prefs, id)
			return PREFERENCES_REFRESH_UPDATE_PREVIEW
	return ..()

/datum/category_item/player_setup_item/background/faction/filter(datum/preferences/prefs, data, list/errors)
	var/datum/lore/character_background/faction/current = SScharacters.resolve_faction(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		return SScharacters.resolve_religion(/datum/lore/character_background/faction/nanotrasen).id
	return data

/datum/category_item/player_setup_item/background/faction/copy_to_mob(mob/M, data, flags)
	#warn impl

/datum/category_item/player_setup_item/background/faction/spawn_checks(datum/preferences/prefs, data, flags, list/errors)
	var/datum/lore/character_background/faction/current = SScharacters.resolve_faction(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		errors?.Add("Invalid faction for your current species.")
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/faction/default_value(randomizing)
	return SScharacters.resolve_faction(/datum/lore/character_background/faction/nanotrasen).id

/datum/category_item/player_setup_item/background/faction/informed_default_value(datum/preferences/prefs, randomizing)
	var/datum/character_species/S = SScharacters.resolve_character_species(prefs.character_species_id())
	if(!S)
		return ..()
	return S.get_default_faction_id()

/datum/preferences/proc/lore_faction_id()
	return get_character_data(CHARACTER_DATA_FACTION)

/datum/preferences/proc/lore_faction_datum()
	return SScharacters.resolve_faction(lore_faction_id())
