#warn deal with these they access language vars
/datum/category_item/player_setup_item/general/language/content(datum/preferences/prefs, mob/user, data)
	. += "<b>Languages</b><br>"
	var/datum/species/S = pref.real_species_datum()
	if(S.language)
		. += "- [S.language]<br>"
	if(S.default_language && S.default_language != S.language)
		. += "- [S.default_language]<br>"
	if(S.max_additional_languages)
		if(pref.alternate_languages.len)
			for(var/i = 1 to pref.alternate_languages.len)
				var/lang = pref.alternate_languages[i]
				. += "- [lang] - <a href='?src=\ref[src];remove_language=[i]'>remove</a><br>"

		if(pref.alternate_languages.len < S.max_additional_languages)
			. += "- <a href='?src=\ref[src];add_language=1'>add</a> ([S.max_additional_languages - pref.alternate_languages.len] remaining)<br>"
	else
		. += "- [pref.species] cannot choose secondary languages.<br>"

/datum/category_item/player_setup_item/general/language/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["remove_language"])
		var/index = text2num(href_list["remove_language"])
		pref.alternate_languages.Cut(index, index+1)
		return PREFERENCES_REFRESH
	else if(href_list["add_language"])
		var/datum/species/S = pref.real_species_datum()
		if(pref.alternate_languages.len >= S.max_additional_languages)
			alert(user, "You have already selected the maximum number of alternate languages for this species!")
		else
			var/list/available_languages = S.secondary_langs.Copy()
			for(var/datum/language/lang as anything in SScharacters.all_languages())
				if(!(lang.language_flags & RESTRICTED) && (is_lang_whitelisted(user, lang)))
					available_languages |= lang.name

			// make sure we don't let them waste slots on the default languages
			available_languages -= S.language
			available_languages -= S.default_language
			available_languages -= pref.alternate_languages

			if(!available_languages.len)
				alert(user, "There are no additional languages available to select.")
			else
				var/new_lang = input(user, "Select an additional language", "Character Generation", null) as null|anything in available_languages
				if(new_lang && pref.alternate_languages.len < S.max_additional_languages)
					pref.alternate_languages |= new_lang
					return PREFERENCES_REFRESH
