/datum/category_item/player_setup_item/background/faction
	name = "Faction"
	save_key = CHARACTER_DATA_FACTION
	load_order = PREFERENCE_LOAD_ORDER_LORE_FACTION
	sort_order = 7

/datum/category_item/player_setup_item/background/faction/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/datum/lore/character_background/faction/available = SScharacters.available_factions(prefs.character_species_id(), prefs.lore_origin_id(), prefs.lore_citizenship_id())
	var/list/categories = list()
	var/datum/lore/character_background/faction/current = SScharacters.resolve_faction(data)
	var/current_category
	for(var/datum/lore/character_background/faction/O as anything in available)
		LAZYADD(categories[O.category], O)
		if(O == current)
			current_category = O.category
	. += "<center>"
	. += "<b>Faction</b><br>"
	if(length(categories) > 1)
		for(var/category in categories)
			. += (category == current.category)? "<span class='linkOn'>[category]</span> " : href_simple(prefs, "category", "[category]", category)
			. += " "
		. += "<br>"
	for(var/datum/lore/character_background/faction/O in available)
		if(O == current)
			. += "<span class='linkOn'>[O.name]</span>"
		else if(current_category && O.category != current_category)
			continue
		else
			. += href_simple(prefs, "pick", "[O.name]", O.id)
		. += " "
	. += "</center>"
	. += "<div class='statusDisplay'>"
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
			prefs.sanitize_background_lore()	// update
			GLOB.join_menu?.update_static_data(user)
			return PREFERENCES_REFRESH_UPDATE_PREVIEW
		if("category")
			var/cat = params["category"]
			var/list/datum/lore/character_background/faction/factions = SScharacters.available_factions(prefs.character_species_id(), category = cat)
			if(!length(factions))
				to_chat(user, SPAN_WARNING("No factions in that category have been found; this might be an error."))
				return PREFERENCES_NOACTION
			var/datum/lore/character_background/faction/first = factions[1]
			write(prefs, first.id)
			prefs.sanitize_background_lore()	// update
			return PREFERENCES_REFRESH
	return ..()

/datum/category_item/player_setup_item/background/faction/filter_data(datum/preferences/prefs, data, list/errors)
	var/datum/lore/character_background/faction/current = SScharacters.resolve_faction(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		return SScharacters.resolve_faction(/datum/lore/character_background/faction/nanotrasen).id
	// thanks papalus
	var/datum/lore/character_background/origin/origin = prefs.lore_origin_datum()
	if(current.origin_whitelist && !(origin.id in current.origin_whitelist))
		return SScharacters.resolve_faction(/datum/lore/character_background/faction/nanotrasen).id
	var/datum/lore/character_background/citizenship/citizenship = prefs.lore_citizenship_datum()
	if(current.citizenship_whitelist && !(citizenship.id in current.citizenship_whitelist))
		return SScharacters.resolve_faction(/datum/lore/character_background/faction/nanotrasen).id
	return data

/datum/category_item/player_setup_item/background/faction/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	// todo: sources - this one is from culture/bcakground
	var/datum/lore/character_background/B = SScharacters.resolve_faction(data)
	for(var/id in B.innate_languages)
		M.add_language(id)
	return TRUE

/datum/category_item/player_setup_item/background/faction/spawn_checks(datum/preferences/prefs, data, flags, list/errors, list/warnings)
	var/datum/lore/character_background/faction/current = SScharacters.resolve_faction(data)
	if(!current?.check_species_id(prefs.character_species_id()))
		errors?.Add("Invalid faction for your current species.")
		return FALSE
	// thanks papalus
	var/datum/lore/character_background/origin/origin = prefs.lore_origin_datum()
	if(current.origin_whitelist && !(origin.id in current.origin_whitelist))
		errors?.Add("Your current faction is not allowed to be chosen by your origin.")
		return FALSE
	var/datum/lore/character_background/citizenship/citizenship = prefs.lore_citizenship_datum()
	if(current.citizenship_whitelist && !(citizenship.id in current.citizenship_whitelist))
		errors?.Add("Your current faction is not allowed to be chosen by your citizenship.")
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
	RETURN_TYPE(/datum/lore/character_background/faction)
	return SScharacters.resolve_faction(get_character_data(CHARACTER_DATA_FACTION))

/datum/preferences/proc/lore_faction_job_check(datum/role/job/J)
	return lore_faction_datum()?.check_job_id(J.id)
