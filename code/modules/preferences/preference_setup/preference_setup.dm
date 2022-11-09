#define PREF_FBP_CYBORG "cyborg"
#define PREF_FBP_POSI "posi"
#define PREF_FBP_SOFTWARE "software"

/datum/category_group/player_setup_category/general_preferences
	name = "General"
	sort_order = 1
	category_item_type = /datum/category_item/player_setup_item/general

/datum/category_group/player_setup_category/appearance_preferences
	name = "Antagonism"
	sort_order = 4
	category_item_type = /datum/category_item/player_setup_item/antagonism

/datum/category_group/player_setup_category/loadout_preferences
	name = "Loadout"
	sort_order = 5
	category_item_type = /datum/category_item/player_setup_item/loadout

/datum/category_group/player_setup_category/global_preferences
	name = "Global"
	sort_order = 6
	category_item_type = /datum/category_item/player_setup_item/player_global

/****************************
* Category Collection Setup *
****************************/
/datum/category_collection/player_setup_collection
	category_group_type = /datum/category_group/player_setup_category
	var/datum/preferences/preferences
	var/datum/category_group/player_setup_category/selected_category = null

/datum/category_collection/player_setup_collection/New(var/datum/preferences/preferences)
	src.preferences = preferences
	..()
	selected_category = categories[1]
	tim_sort(preferences.preference_by_key, /proc/cmp_preference_load_order, TRUE)

/datum/category_collection/player_setup_collection/Destroy()
	preferences = null
	selected_category = null
	return ..()

/datum/category_collection/player_setup_collection/proc/sanitize_setup()
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.sanitize_setup()

/datum/category_collection/player_setup_collection/proc/load_character(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_character(S)

/datum/category_collection/player_setup_collection/proc/save_character(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_character(S)

/datum/category_collection/player_setup_collection/proc/load_preferences(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_preferences(S)

/datum/category_collection/player_setup_collection/proc/save_preferences(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_preferences(S)

/datum/category_collection/player_setup_collection/proc/header()
	var/dat = ""
	for(var/datum/category_group/player_setup_category/PS in categories)
		if(PS == selected_category)
			dat += "[PS.name] "	// TODO: Check how to properly mark a href/button selected in a classic browser window
		else
			dat += "<a href='?src=\ref[src];category=\ref[PS]'>[PS.name]</a> "
	return dat

/datum/category_collection/player_setup_collection/proc/content(var/mob/user)
	if(selected_category)
		return selected_category.content(user)

/datum/category_collection/player_setup_collection/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(!user.client)
		return 1

	if(href_list["category"])
		var/category = locate(href_list["category"])
		if(category && (category in categories))
			selected_category = category
		. = 1

	if(.)
		user.client.prefs.ShowChoices(user)

/**************************
* Category Category Setup *
**************************/
/datum/category_group/player_setup_category
	var/datum/preferences/prefs
	var/sort_order = 0
	/// automatically split into 2 horizontally
	var/auto_split = TRUE
	/// automatic <hr>
	var/auto_rule = FALSE

/datum/category_group/player_setup_category/New()
	. = ..()
	var/datum/category_collection/player_setup_collection/C = collection
	prefs = C.preferences

/datum/category_group/player_setup_category/compare_to(datum/D)
	if(istype(D, /datum/category_group/player_setup_category))
		var/datum/category_group/player_setup_category/G = D
		return cmp_numeric_asc(sort_order, G.sort_order)
	return ..()

/datum/category_group/player_setup_category/proc/sanitize_setup()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()

/datum/category_group/player_setup_category/proc/load_character(var/savefile/S)
	// Load all data, then sanitize it.
	// Need due to, for example, the 01_basic module relying on species having been loaded to sanitize correctly but that isn't loaded until module 03_body.
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_character(S)

/datum/category_group/player_setup_category/proc/save_character(var/savefile/S)
	// Sanitize all data, then save it
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_character()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_character(S)

/datum/category_group/player_setup_category/proc/load_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.load_preferences(S)

/datum/category_group/player_setup_category/proc/save_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/PI in items)
		PI.save_preferences(S)

/datum/category_group/player_setup_category/proc/content(var/mob/user)
	. = "<table style='width:100%'><tr style='vertical-align:top'><td style='width:50%'>"
	if(auto_split)
		var/current = 0
		var/halfway = items.len / 2
		for(var/datum/category_item/player_setup_item/PI in items)
			var/data
			if(PI.save_key)
				data = PI.is_global? prefs.get_global_data(PI.save_key) : prefs.get_character_data(PI.save_key)
			var/list/c = PI.content(PI.pref, user, data)
			if(!length(c))
				continue
			if(current && auto_rule)
				. += "<br>"
			if(halfway && current++ >= halfway)
				halfway = 0
				. += "</td><td></td><td style='width:50%'>"
			. += "[islist(c)? c.Join("") : c]<br>"
		. += "</td></tr></table>"
	else
		var/current = 0
		for(var/datum/category_item/player_setup_item/PI in items)
			var/data
			if(PI.save_key)
				data = PI.is_global? prefs.get_global_data(PI.save_key) : prefs.get_character_data(PI.save_key)
			var/list/content = PI.content(PI.pref, user, data)
			if(!length(content))
				continue
			if(current && auto_rule)
				. += "<hr>"
			current++
			. += islist(content)? content.Join("") : content

/**********************
* Category Item Setup *
**********************/
/datum/category_item/player_setup_item
	var/sort_order = 0
	var/datum/preferences/pref

/datum/category_item/player_setup_item/New()
	..()
	var/datum/category_collection/player_setup_collection/psc = category.collection
	pref = psc.preferences
	pref.preference_datums += src
	if(save_key)
		pref.preference_by_key[save_key] = src
	pref.preference_by_type[type] = src

/datum/category_item/player_setup_item/Destroy()
	pref = null
	return ..()

/datum/category_item/player_setup_item/compare_to(datum/D)
	if(istype(D, /datum/category_item/player_setup_item))
		var/datum/category_item/player_setup_item/I = D
		return cmp_numeric_asc(sort_order, I.sort_order)
	return ..()

/*
* Called when the item is asked to load per character settings
*/
/datum/category_item/player_setup_item/proc/load_character(var/savefile/S)
	return

/*
* Called when the item is asked to save per character settings
*/
/datum/category_item/player_setup_item/proc/save_character(var/savefile/S)
	return

/*
* Called when the item is asked to load user/global settings
*/
/datum/category_item/player_setup_item/proc/load_preferences(var/savefile/S)
	return

/*
* Called when the item is asked to save user/global settings
*/
/datum/category_item/player_setup_item/proc/save_preferences(var/savefile/S)
	return

/datum/category_item/player_setup_item/proc/sanitize_character()
	return

/datum/category_item/player_setup_item/proc/sanitize_preferences()
	return

/datum/category_item/player_setup_item/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/pref_mob = preference_mob()
	if(!pref_mob || !pref_mob.client)
		return 1

	. = OnTopic(href, href_list, usr)
	var/resolved = href_list["act"]
	. |= act(pref, usr, resolved, href_list)

	if(. & PREFERENCES_UPDATE_PREVIEW)
		pref_mob.client.prefs.update_preview_icon()
	if(. & PREFERENCES_REFRESH)
		pref_mob.client.prefs.ShowChoices(usr)

/datum/category_item/player_setup_item/CanUseTopic(var/mob/user)
	return 1

/datum/category_item/player_setup_item/proc/OnTopic(var/href,var/list/href_list, var/mob/user)
	return PREFERENCES_NOACTION

/datum/category_item/player_setup_item/proc/preference_mob()
	if(!pref.client)
		for(var/client/C)
			if(C.ckey == pref.client_ckey)
				pref.client = C
				break

	if(pref.client)
		return pref.client.mob

/// Checks in a really hacky way if a character's preferences say they are an FBP or not.
/datum/category_item/player_setup_item/proc/is_FBP()
	if(pref.organ_data && pref.organ_data[BP_TORSO] != "cyborg")
		return FALSE
	return TRUE

/// Returns what kind of FBP the player's prefs are.  Returns FALSE if they're not an FBP.
/datum/category_item/player_setup_item/proc/get_FBP_type()
	if(!is_FBP())
		return FALSE // Not a robot.
	if(O_BRAIN in pref.organ_data)
		switch(pref.organ_data[O_BRAIN])
			if("assisted")
				return PREF_FBP_CYBORG
			if("mechanical")
				return PREF_FBP_POSI
			if("digital")
				return PREF_FBP_SOFTWARE
	return FALSE //Something went wrong!

/datum/category_item/player_setup_item/proc/get_min_age() // Minimum limit is 18
	var/datum/species/S = pref.real_species_datum()
	if(S.min_age > 18)
		return S.min_age
	else if(!is_FBP())
		S.min_age = 18
	return S.min_age

/datum/category_item/player_setup_item/proc/get_max_age()
	var/datum/species/S = pref.real_species_datum()
	if(!is_FBP())
		return S.max_age // If they're not a robot, we can just use the species var.
	var/FBP_type = get_FBP_type()
	switch(FBP_type)
		if(PREF_FBP_CYBORG)
			return S.max_age + 20
		if(PREF_FBP_SOFTWARE)
			return S.max_age + 80
		if(PREF_FBP_POSI)
			return S.max_age + 150
	return S.max_age // welp

/datum/category_item/player_setup_item/proc/color_square(red, green, blue, hex)
	var/color = hex ? hex : "#[num2hex(red, 2)][num2hex(green, 2)][num2hex(blue, 2)]"
	return "<span style='font-face: fixedsys; font-size: 14px; background-color: [color]; color: [color]'>___</span>"
