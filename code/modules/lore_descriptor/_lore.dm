#define COLLAPSED_LORE_BLURB_LEN 48

/datum/lore_info
	var/name
	var/desc_type
	var/description
	var/economic_power = 1
	var/language = LANGUAGE_GALCOM
	var/name_language
	var/default_language
	var/list/optional_languages
	var/list/secondary_langs
	var/common_langs
	var/has_common_langs = TRUE
//	var/list/max_languages = 20 // Implementing later, going to use the species one for now.
	var/category
	var/subversive_potential = 0
	var/hidden


/datum/lore_info/New()

	if(!default_language)
		default_language = language

	if(!name_language && default_language)
		name_language = default_language

	// Remove any overlap for the sake of presentation.
	if(LAZYLEN(optional_languages))
		optional_languages -= language
		optional_languages -= name_language
		optional_languages -= default_language
		UNSETEMPTY(optional_languages)

	if(LAZYLEN(secondary_langs))
		secondary_langs -= language
		secondary_langs -= name_language
		secondary_langs -= default_language
		if(LAZYLEN(optional_languages))
			secondary_langs -= optional_languages
		UNSETEMPTY(secondary_langs)

	..()

/datum/lore_info/proc/get_random_name(var/gender)
	var/datum/language/_language
	if(name_language)
		_language = GLOB.all_languages[name_language]
	else if(default_language)
		_language = GLOB.all_languages[default_language]
	else if(language)
		_language = GLOB.all_languages[language]
	if(_language)
		return _language.get_random_name(gender)
	return capitalize(pick(gender==FEMALE ? first_names_female : first_names_male)) + " " + capitalize(pick(last_names))


/datum/lore_info/proc/sanitize_name(var/new_name)
	return sanitizeName(new_name)


/datum/lore_info/proc/get_description(var/header, var/append, var/verbose = TRUE)
	var/list/dat = list()
	dat += "<table padding='8px'><tr>"
	dat += "<td width='260px'>"
	dat += "[header ? header : "<b>[desc_type]:</b>[name]"]<br>"
	if(verbose)
		dat += "<small>"
		dat += "[jointext(get_text_details(), "<br>")]"
		dat += "</small>"
	dat += "</td><td width>"
	if(verbose || length(get_text_body()) <= COLLAPSED_LORE_BLURB_LEN)
		dat += "[get_text_body()]"
	else
		dat += "[copytext(get_text_body(), 1, COLLAPSED_LORE_BLURB_LEN)] \[...\]"
	dat += "</td>"
	if(append)
		dat += "<td width = '100px'>[append]</td>"
	dat += "</tr></table><hr>"
	return jointext(dat, null)


/datum/lore_info/proc/get_text_body()
	return description


/datum/lore_info/proc/get_text_details()
	. = list()
	var/list/spoken_langs = get_spoken_languages()
	if(LAZYLEN(spoken_langs))
		. += "<b>Language(s):</b> [english_list(spoken_langs)]."
	if(LAZYLEN(secondary_langs))
		. += "<b>Optional language(s):</b> [english_list(secondary_langs)]."
	if(!isnull(economic_power))
		. += "<b>Economic power:</b> [round(100 * economic_power)]%"


/datum/lore_info/proc/get_spoken_languages()
	. = list()
	if(language) . |= language
	if(default_language) . |= default_language
	if(name_language) . |= name_language
	if(LAZYLEN(optional_languages)) . |= optional_languages


/decl/cultural_info/proc/format_formal_name(var/character_name)
	return character_name

/decl/cultural_info/proc/get_qualifications()
	return


#undef COLLAPSED_LORE_BLURB_LEN
