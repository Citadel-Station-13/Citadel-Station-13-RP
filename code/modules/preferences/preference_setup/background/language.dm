/datum/category_item/player_setup_item/background/language
	name = "Language"
	sort_order = 4
	save_key = CHARACTER_DATA_LANGUAGES
	load_order = PREFERENCE_LOAD_ORDER_LANGUAGE

/datum/category_item/player_setup_item/background/language/content(datum/preferences/prefs, mob/user, data)
	. = list()
	var/list/language_ids = read(prefs)


#warn how are we going to UI this

/datum/category_item/player_setup_item/background/language/act(datum/preferences/prefs, mob/user, action, list/params)
	. = ..()
	if(.)
		return

/datum/category_item/player_setup_item/background/language/filter(datum/preferences/prefs, data, list/errors)
	var/list/languages = sanitize_islist(data)
	var/list/innate = prefs.innate_language_ids()
	var/list/extra = languages - innate
	languages = innate
	var/extra_max = prefs.extraneous_languages_max()
	if(extra.len > extra_max)
		var/list/truncated = extra.Copy(extra_max + 1)
		extra.len = clamp(extra.len, 0, extra_max)
		errors?.Add(SPAN_WARNING("truncated [english_list(truncated)] languages - too many!"))
	languages = languages + extra
	return languages

/datum/category_item/player_setup_item/background/language/copy_to_mob(datum/preferences/prefs, mob/M, data, flags)
	if(!ishuman(M))
		return TRUE
	var/mob/living/carbon/human/H = M
	// todo: sources
	for(var/id in data)
		H.add_language(id)

/datum/category_item/player_setup_item/background/language/spawn_checks(datum/preferences/prefs, data, flags, list/errors)
	if(length(data) > prefs.extraneous_languages_max())
		errors?.Add(SPAN_WARNING("You have selected too many extra languages for your species and culture."))
		return FALSE
	return TRUE

/datum/category_item/player_setup_item/background/language/default_value(randomizing)
	return list(LANGUAGE_ID_COMMON)

/datum/category_item/player_setup_item/background/language/informed_default_value(datum/preferences/prefs, randomizing)
	return prefs.innate_language_ids()

/**
 * returns ids of languages that are innate to our species/background
 */
/datum/preferences/proc/innate_language_ids(include_common = TRUE, include_species = TRUE, include_background = TRUE)

	#warn resolve backgrounds + species + defaults + collate

/**
 * returns max amounts we can have. doesn't take into account what we do have.
 */
/datum/preferences/proc/extraneous_languages_max()
	return character_species_datum().max_additional_languages

/**
 * returns ids of languages that aren't innate to our species/background
 */
/datum/preferences/proc/extraneous_languages()
	return get_character_data(CHARACTER_DATA_LANGUAGES) - innate_language_ids()
