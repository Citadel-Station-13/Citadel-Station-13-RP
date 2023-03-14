/datum/category_item/player_setup_item/background/language
	name = "Language"
	sort_order = 1.5
	save_key = CHARACTER_DATA_LANGUAGES
	load_order = PREFERENCE_LOAD_ORDER_LANGUAGE

/datum/category_item/player_setup_item/background/language/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/innate_names = list()
	for(var/id in prefs.innate_language_ids())
		var/datum/language/L = SScharacters.resolve_language_id(id)
		innate_names += L.name
	. += "<center><b>Languages</b></center>"
	. += "<div class='statusDisplay'>"
	. += "&nbsp&nbsp&nbsp&nbspIntrinsic (Species, Backgrounds, Cultures): [english_list(innate_names)]<br>"
	. += "&nbsp&nbsp&nbsp&nbspAdditional: "
	var/count = 0
	for(var/id in prefs.extraneous_language_ids())
		++count
		var/datum/language/L = SScharacters.resolve_language_id(id)
		. += "[L.name] [href_simple(prefs, "remove", "Remove", id)]"
		. += " "
	if(count < prefs.extraneous_languages_max())
		. += "[href_simple(prefs, "add", "Add")]"
	. += "</div>"

/datum/category_item/player_setup_item/background/language/act(datum/preferences/prefs, mob/user, action, list/params)
	switch(action)
		if("add")
			prefs.language_pick(user)
			return PREFERENCES_HANDLED
		if("remove")
			var/id = params["remove"]
			var/list/existing = read(prefs)
			if(existing.Remove(id))
				write(prefs, existing)
				return PREFERENCES_REFRESH
			return PREFERENCES_NOACTION
	return ..()

/datum/category_item/player_setup_item/background/language/filter_data(datum/preferences/prefs, data, list/errors)
	var/list/languages = sanitize_islist(data)
	var/list/innate = prefs.innate_language_ids()
	var/list/extra = languages.Copy()
	extra -= innate
	var/extra_max = prefs.extraneous_languages_max()
	if(extra.len > extra_max)
		var/list/truncated = extra.Copy(extra_max + 1)
		extra.len = clamp(extra.len, 0, extra_max)
		errors?.Add(SPAN_WARNING("truncated [english_list(truncated)] languages - too many!"))
	return extra

/datum/category_item/player_setup_item/background/language/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/H = M
	// todo: sources - this one is extraneous
	for(var/id in data)
		H.add_language(id)

/datum/category_item/player_setup_item/background/language/spawn_checks(datum/preferences/prefs, data, flags, list/errors, list/warnings)
	if(length(data) > prefs.extraneous_languages_max())
		errors?.Add(SPAN_WARNING("You have selected too many extra languages for your species and culture."))
		return FALSE
	var/list/extraneous = data
	var/datum/character_species/CS = prefs.character_species_datum()
	for(var/id in extraneous)
		var/datum/language/L = SScharacters.resolve_language_id(id)
		if((L.language_flags & LANGUAGE_WHITELISTED) && (!(L in CS.whitelist_languages)) && !config.check_alien_whitelist(ckey(L.name), prefs.client_ckey))
			errors?.Add(SPAN_WARNING("[L.id] is a whitelisted language."))
			return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/language/default_value(randomizing)
	return list(LANGUAGE_ID_COMMON)

/datum/category_item/player_setup_item/background/language/informed_default_value(datum/preferences/prefs, randomizing)
	return prefs.innate_language_ids()

/**
 * returns ids of languages that are innate to our species/background
 */
/datum/preferences/proc/innate_language_ids(include_background = TRUE)
	RETURN_TYPE(/list)
	var/datum/character_species/S = character_species_datum()
	. = S.get_intrinsic_language_ids()
	if(include_background)
		var/list/datum/lore/character_background/backgrounds = list(
			lore_citizenship_datum(),
			lore_origin_datum(),
			lore_religion_datum(),
			lore_faction_datum()
		)
		for(var/datum/lore/character_background/B in backgrounds)	// eh let's type filter
			if(!B.innate_languages)
				continue
			. |= B.innate_languages

/**
 * returns max amounts we can have. doesn't take into account what we do have.
 */
/datum/preferences/proc/extraneous_languages_max()
	var/list/datum/lore/character_background/backgrounds = list(
		lore_citizenship_datum(),
		lore_origin_datum(),
		lore_religion_datum(),
		lore_faction_datum()
	)
	var/tally = character_species_datum().max_additional_languages
	for(var/datum/lore/character_background/B in backgrounds)	// eh let's type filter
		tally += B.language_amount_mod
	return max(tally, 0)

/**
 * returns ids of languages that aren't innate to our species/background
 */
/datum/preferences/proc/extraneous_language_ids()
	RETURN_TYPE(/list)
	return get_character_data(CHARACTER_DATA_LANGUAGES) - innate_language_ids()

/**
 * returns ids of ALL languages
 */
/datum/preferences/proc/all_language_ids()
	RETURN_TYPE(/list)
	return innate_language_ids() + get_character_data(CHARACTER_DATA_LANGUAGES)
