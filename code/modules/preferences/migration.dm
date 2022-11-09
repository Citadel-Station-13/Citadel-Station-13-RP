/**
 * @params
 * - S - the savefile we operate on
 * - current_version - the version it's at
 * - errors - put errors into this list to be displayed to the player
 * - options - the loaded global options list
 */
/datum/preferences/proc/perform_global_migrations(savefile/S, current_version, list/errors, list/options)
	if(current_version < 13)
		addtimer(CALLBACK(src, .proc/force_reset_keybindings), 5 SECONDS)
	if(current_version < 15)
		var/list/language_prefixes
		S["language_prefixes"] >> language_prefixes
		if(!islist(language_prefixes))
			language_prefixes = list()
		options[GLOBAL_DATA_LANGUAGE_PREFIX] = language_prefixes.Copy()

/**
 * @params
 * - S - the savefile we operate on
 * - current_version - the version it's at
 * - errors - put errors into this list to be displayed to the player
 * - options - the loaded character options list
 */
/datum/preferences/proc/perform_character_migrations(savefile/S, current_version, list/errors, list/character)
	if(current_version < 1)
		// MIGRATE JOBS
		var/alternative_option
		var/job_civilian_high
		var/job_civilian_med
		var/job_civilian_low
		var/job_medsci_high
		var/job_medsci_low
		var/job_medsci_med
		var/job_talon_high
		var/job_talon_low
		var/job_talon_med
		var/job_engsec_high
		var/job_engsec_med
		var/job_engsec_low
		var/list/player_alt_titles
		READ_FILE(S["alternate_option"],  alternative_option)
		READ_FILE(S["job_civilian_high"], job_civilian_high)
		READ_FILE(S["job_civilian_med"],  job_civilian_med)
		READ_FILE(S["job_civilian_low"],  job_civilian_low)
		READ_FILE(S["job_medsci_high"],   job_medsci_high)
		READ_FILE(S["job_medsci_med"],    job_medsci_med)
		READ_FILE(S["job_medsci_low"],    job_medsci_low)
		READ_FILE(S["job_engsec_high"],   job_engsec_high)
		READ_FILE(S["job_engsec_med"],    job_engsec_med)
		READ_FILE(S["job_engsec_low"],    job_engsec_low)
		READ_FILE(S["job_talon_low"],     job_talon_low)
		READ_FILE(S["job_talon_med"],     job_talon_med)
		READ_FILE(S["job_talon_high"],    job_talon_high)
		READ_FILE(S["player_alt_titles"], player_alt_titles)
		var/list/assembled = list()
		var/list/assembled_titles = list()
		if(!islist(player_alt_titles))
			player_alt_titles = list()
		for(var/datum/job/J as anything in SSjob.occupations)
			switch(J.department_flag)
				if(CIVILIAN)
					if(job_civilian_high & J.flag)
						assembled[J.id] = JOB_PRIORITY_HIGH
					else if(job_civilian_med & J.flag)
						assembled[J.id] = JOB_PRIORITY_MEDIUM
					else if(job_civilian_low & J.flag)
						assembled[J.id] = JOB_PRIORITY_LOW
				if(MEDSCI)
					if(job_medsci_high & J.flag)
						assembled[J.id] = JOB_PRIORITY_HIGH
					else if(job_medsci_med & J.flag)
						assembled[J.id] = JOB_PRIORITY_MEDIUM
					else if(job_medsci_low & J.flag)
						assembled[J.id] = JOB_PRIORITY_LOW
				if(ENGSEC)
					if(job_engsec_high & J.flag)
						assembled[J.id] = JOB_PRIORITY_HIGH
					else if(job_engsec_med & J.flag)
						assembled[J.id] = JOB_PRIORITY_MEDIUM
					else if(job_engsec_low & J.flag)
						assembled[J.id] = JOB_PRIORITY_LOW
			if(player_alt_titles[J.title])
				assembled_titles[J.id] = player_alt_titles[J.title]
		var/overflow
		switch(alternative_option)
			if(0)
				overflow = JOB_ALTERNATIVE_GET_RANDOM
			if(1)
				overflow = JOB_ALTERNATIVE_BE_ASSISTANT
			if(2)
				overflow = JOB_ALTERNATIVE_RETURN_LOBBY
		character[CHARACTER_DATA_JOBS] = assembled
		character[CHARACTER_DATA_OVERFLOW_MODE] = overflow
		character[CHARACTER_DATA_ALT_TITLES] = assembled_titles
		// BACKGROUNDS: NOT MIGRATED
		// MIGRATE SPECIES
		var/name_species
		S["species"] >> name_species
		var/datum/species/RS = SScharacters.resolve_species_name(name_species)
		if(!RS)
			if(name_species)	// if they had any at all
				errors?.Add(SPAN_WARNING("Species reset to human - no species found of old species name ([name_species])"))
			RS = SScharacters.resolve_species_path(/datum/species/human)
			// todo: default species?
		if(RS)
			character[CHARACTER_DATA_REAL_SPECIES] = RS.uid
			character[CHARACTER_DATA_CHAR_SPECIES] = RS.uid
		else
			errors?.Add(SPAN_DANGER("Species migration failed - no species datum. Report this to a coder."))
		// MIGRATE LANGUAGES
		var/list/alternate_languages
		S["language"] >> alternate_languages
		if(!islist(alternate_languages))
			alternate_languages = list()
		var/list/translated_languages = list()
		character[CHARACTER_DATA_LANGUAGES] = translated_languages
		var/list/innate = innate_language_ids()
		for(var/name in alternate_languages)
			var/datum/language/L = SScharacters.resolve_language_name(name)
			if(L.id in innate)
				continue
			translated_languages += L.id
		translated_languages.len = clamp(translated_languages.len, 0, extraneous_languages_max())
	if(current_version < 2)
		character -= GLOBAL_DATA_LANGUAGE_PREFIX
