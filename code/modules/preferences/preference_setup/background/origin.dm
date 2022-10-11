/datum/category_item/player_setup_item/background/origin
	save_key = CHARACTER_DATA_ORIGIN
	sort_order = 2

/datum/category_item/player_setup_item/background/origin/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/datum/lore/character_background/origin/available = SScharacters.available_origins(prefs.character_species_id())
	var/datum/lore/character_background/origin/current = SScharacters.character_origins[data]
	. += "<center>"
	for(var/datum/lore/character_background/origin/O in current)
		. += href_simple(prefs, "pick", "[O.name] ", O.id)
	. += "</center>"
	. += "<div>"
	. += current? current.desc : "<center>error; origin load failed</center>"
	. += "</div>"

/datum/category_item/player_setup_item/background/origin/act(datum/preferences/prefs, mob/user, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("pick")
			var/id = params["pick"]
			#warn impl

/datum/category_item/player_setup_item/background/origin/filter(datum/preferences/prefs, data, list/errors)
	var/datum/lore/character_background/origin/current = SScharacters.character_origins[data]
	if(!current?.check_species_id(prefs.character_species_id()))
		return "custom"	// this is hardcoded; if things break, sucks for you.
						// todo: put all ids on defines when lorewriters are done messing around
	return data

/datum/category_item/player_setup_item/background/origin/copy_to_mob(mob/M, data, flags)
	#warn impl

/datum/category_item/player_setup_item/background/origin/spawn_checks(datum/preferences/prefs, data, flags, list/errors)
	var/datum/lore/character_background/origin/current = SScharacters.character_origins[data]
	if(!current?.check_species_id(prefs.character_species_id()))
		errors?.Add("Invalid origin for your current species.")
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/origin/default_value(randomizing)
	return "custom"

/datum/category_item/player_setup_item/background/origin/informed_default_value(datum/preferences/prefs, randomizing)
	var/datum/character_species/S = SScharacters.resolve_character_species(prefs.character_species_id())
	if(!S)
		return ..()
	return S.get_default_origin_id()

#warn impl above
