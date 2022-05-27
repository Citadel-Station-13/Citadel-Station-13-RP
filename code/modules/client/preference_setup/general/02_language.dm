/datum/category_item/player_setup_item/general/language
	name = "Language"
	sort_order = 2

/datum/category_item/player_setup_item/general/language/load_character(savefile/S)
	from_file(S["language"], pref.alternate_languages)
	from_file(S["language_prefixes"], pref.language_prefixes)

/datum/category_item/player_setup_item/general/language/save_character(savefile/S)
	to_file(S["language"], pref.alternate_languages)
	to_file(S["language_prefixes"], pref.language_prefixes)

/datum/category_item/player_setup_item/general/language/sanitize_character()
	if(!islist(pref.alternate_languages))
		pref.alternate_languages = list()
	if(pref.species)
		var/datum/species/S = pref.character_static_species_meta()
		if(S && pref.alternate_languages.len > S.num_alternate_languages)
			pref.alternate_languages.len = S.num_alternate_languages // Truncate to allowed length
	if(isnull(pref.language_prefixes) || !pref.language_prefixes.len)
		pref.language_prefixes = config_legacy.language_prefixes.Copy()

/datum/category_item/player_setup_item/general/language/content()
	. += "<b>Languages</b><br>"
	var/datum/species/S = pref.character_static_species_meta()
	if(S.language)
		. += "- [S.language]<br>"
	if(S.default_language && S.default_language != S.language)
		. += "- [S.default_language]<br>"
	if(S.num_alternate_languages)
		if(pref.alternate_languages.len)
			for(var/i = 1 to pref.alternate_languages.len)
				var/lang = pref.alternate_languages[i]
				. += "- [lang] - <a href='?src=\ref[src];remove_language=[i]'>remove</a><br>"

		if(pref.alternate_languages.len < S.num_alternate_languages)
			. += "- <a href='?src=\ref[src];add_language=1'>add</a> ([S.num_alternate_languages - pref.alternate_languages.len] remaining)<br>"
	else
		. += "- [pref.species] cannot choose secondary languages.<br>"

	. += "<b>Language Keys</b><br>"
	. += " [jointext(pref.language_prefixes, " ")] <a href='?src=\ref[src];change_prefix=1'>Change</a> <a href='?src=\ref[src];reset_prefix=1'>Reset</a><br>"

/datum/category_item/player_setup_item/general/language/OnTopic(href, list/href_list, mob/user)
	if(href_list["remove_language"])
		var/index = text2num(href_list["remove_language"])
		pref.alternate_languages.Cut(index, index+1)
		return TOPIC_REFRESH
	else if(href_list["add_language"])
		var/datum/species/S = pref.character_static_species_meta()
		if(pref.alternate_languages.len >= S.num_alternate_languages)
			alert(user, "You have already selected the maximum number of alternate languages for this species!")
		else
			var/list/available_languages = S.secondary_langs.Copy()
			for(var/L in GLOB.all_languages)
				var/datum/language/lang = GLOB.all_languages[L]
				if(!(lang.flags & RESTRICTED) && (is_lang_whitelisted(user, lang)))
					available_languages |= L

			// make sure we don't let them waste slots on the default languages
			available_languages -= S.language
			available_languages -= S.default_language
			available_languages -= pref.alternate_languages

			if(!available_languages.len)
				alert(user, "There are no additional languages available to select.")
			else
				var/new_lang = tgui_input_list(user, "Select an additional language", "Languages", null, available_languages)
				if(new_lang && pref.alternate_languages.len < S.num_alternate_languages)
					pref.alternate_languages |= new_lang
					return TOPIC_REFRESH

	else if(href_list["change_prefix"])
		var/char
		var/keys[0]
		do
			char = tgui_input_text("Enter a single special character.\nYou may re-select the same characters.\nThe following characters are already in use by radio: ; : .\nThe following characters are already in use by special say commands: ! * ^", "Enter Character - [3 - keys.len] remaining")
			if(char)
				if(length(char) > 1)
					alert(user, "Only single characters allowed.", "Error", "Ok")
				else if(char in list(";", ":", "."))
					alert(user, "Radio character. Rejected.", "Error", "Ok")
				else if(char in list("!","*", "^"))
					alert(user, "Say character. Rejected.", "Error", "Ok")
				else if(contains_az09(char))
					alert(user, "Non-special character. Rejected.", "Error", "Ok")
				else
					keys.Add(char)
		while(char && keys.len < 3)

		if(keys.len == 3)
			pref.language_prefixes = keys
			return TOPIC_REFRESH
	else if(href_list["reset_prefix"])
		pref.language_prefixes = config_legacy.language_prefixes.Copy()
		return TOPIC_REFRESH

	return ..()
