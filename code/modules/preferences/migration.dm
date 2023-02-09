/**
 * @params
 * - S - the savefile we operate on
 * - current_version - the version it's at
 * - errors - put errors into this list to be displayed to the player
 * - options - the loaded global options list
 * - prefs - prefs if any; if null, we're probably doing a clientless migration.
 */
/datum/controller/subsystem/characters/proc/perform_global_migrations(savefile/S, current_version, list/errors, list/options, datum/preferences/prefs)
	if(current_version < 13)
		if(prefs)
			addtimer(CALLBACK(prefs, /datum/preferences/proc/force_reset_keybindings), 5 SECONDS)
		else
			var/list/new_bindings = deep_copy_list(GLOB.hotkey_keybinding_list_by_key) // give them default keybinds
			WRITE_FILE(S["key_bindings"], new_bindings)
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
 * - prefs - prefs if any; if null, we're probably doing a clientless migration.
 */
/datum/controller/subsystem/characters/proc/perform_character_migrations(savefile/S, current_version, list/errors, list/character, datum/preferences/prefs)
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
		for(var/datum/role/job/J as anything in SSjob.occupations)
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
		// GRAB CHARACTER SPECIES - WE'LL NEED IT
		var/datum/character_species/CS = SScharacters.resolve_character_species(RS.uid)
		// MIGRATE LANGUAGES
		var/list/alternate_languages
		S["language"] >> alternate_languages
		if(!islist(alternate_languages))
			alternate_languages = list()
		var/list/translated_languages = list()
		character[CHARACTER_DATA_LANGUAGES] = translated_languages
		var/list/innate = CS.get_intrinsic_language_ids()
		for(var/name in alternate_languages)
			var/datum/language/L = SScharacters.resolve_language_name(name)
			if(L.id in innate)
				continue
			translated_languages += L.id
		translated_languages.len = clamp(translated_languages.len, 0, CS.get_max_additional_languages())
	if(current_version < 2)
		character -= GLOBAL_DATA_LANGUAGE_PREFIX
	if(current_version < 3)
		// hair_style_name
		// facial_style_name
		// ear_style (type)
		// horn_style (type)
		// tail_style (type)
		// wing_style (type)
		// body_markings (list[name = color])
		//! get
		var/old_hname
		var/old_fname
		var/old_etype
		var/old_htype
		var/old_ttype
		var/old_wtype
		var/old_mnames_colors
		READ_FILE(S["hair_style_name"], old_hname)
		READ_FILE(S["facial_style_name"], old_fname)
		READ_FILE(S["ear_style"], old_etype)
		READ_FILE(S["horn_style"], old_htype)
		READ_FILE(S["wing_style"], old_wtype)
		READ_FILE(S["tail_style"], old_ttype)
		READ_FILE(S["body_markings"], old_mnames_colors)
		old_mnames_colors = sanitize_islist(old_mnames_colors)
		//! gather
		var/datum/sprite_accessory/resolved_hair = GLOB.legacy_hair_lookup[old_hname]
		var/datum/sprite_accessory/resolved_facial = GLOB.legacy_facial_hair_lookup[old_fname]
		var/datum/sprite_accessory/resolved_ears = GLOB.legacy_ears_lookup[old_etype]
		var/datum/sprite_accessory/resolved_horns = GLOB.legacy_ears_lookup[old_htype]
		var/datum/sprite_accessory/resolved_tail = GLOB.legacy_tail_lookup[old_ttype]
		var/datum/sprite_accessory/resolved_wings = GLOB.legacy_wing_lookup[old_wtype]
		var/list/resolved_markings = list()
		for(var/name in old_mnames_colors)
			var/datum/sprite_accessory/resolved_marking = GLOB.legacy_marking_lookup[name]
			if(!resolved_marking)
				continue
			resolved_markings[resolved_marking.id] = old_mnames_colors[name]
		//! write
		WRITE_FILE(S["hair_style"], resolved_hair?.id)
		WRITE_FILE(S["facial_style"], resolved_facial?.id)
		WRITE_FILE(S["ear_style_id"], resolved_ears?.id)
		WRITE_FILE(S["wing_style_id"], resolved_wings?.id)
		WRITE_FILE(S["tail_style_id"], resolved_tail?.id)
		WRITE_FILE(S["horn_style_id"], resolved_horns?.id)
		WRITE_FILE(S["body_marking_ids"], resolved_markings)


/**
 * clientless migration of savefiles
 */
/datum/controller/subsystem/characters/proc/migrate_savefile(path, list/errors = list())
	var/savefile/S
	if(istype(path, /savefile))
		S = path
	else
		S = new(path)
	// perform global - we should be on / when migrations fire
	S.cd = "/"
	var/global_version
	READ_FILE(S["version"], global_version)
	if(!isnum(global_version))
		// no version? assume we don't have one.
		global_version = SAVEFILE_VERSION_MAX
	var/list/global_data
	READ_FILE(S["global"], global_data)
	global_data = sanitize_islist(global_data)
	perform_global_migrations(S, global_version, errors, global_data, null)
	// save global
	global_version = SAVEFILE_VERSION_MAX
	WRITE_FILE(S["version"], global_version)
	WRITE_FILE(S["global"], global_data)
	// migrate all slots
	for(var/i in 1 to config_legacy.character_slots)
		// perform character slot migrations - we should be on /character[slot] when migrations fire
		S.cd = "/"
		var/list/character_data
		var/character_version
		READ_FILE(S["slot_[i]"], character_data)
		character_data = sanitize_islist(character_data)
		character_version = character_data[CHARACTER_DATA_VERSION]
		if(!isnum(character_version))
			// no version? assume it's a legacy file as all new files should have one.
			character_version = CHARACTER_VERSION_LEGACY
		S.cd = "/character[i]"
		perform_character_migrations(S, character_version, errors, character_data, null)
		character_data[CHARACTER_DATA_VERSION] = CHARACTER_VERSION_MAX
		// save character
		S.cd = "/"
		WRITE_FILE(S["slot_[i]"], character_data)

// the oh god oh fuck proc that migrates every file at once
/*
/proc/___migrate_all_savefiles()
	// oh fuck you
	. = 0
	var/timer = REALTIMEOFDAY
	to_chat(world, SPAN_DANGER("Migrating all savefiles. Please do not attempt to use character setup, lest you risk data loss."))
	for(var/path in directory_walk(list("data/player_saves/")))
		var/list/split = splittext(path, "/")
		if(!split.len || (split[split.len] != "preferences.sav"))
			continue
		var/list/what_fucked_up = list()
		SScharacters.migrate_savefile(path, what_fucked_up)
		++.
		if(!(. % 100))
			to_chat(world, SPAN_DANGER("Count: [.]"))
		if(length(what_fucked_up))
			SScharacters.subsystem_log("Migration errored for [path]:\n\t[jointext(what_fucked_up, "\n\t")]")
		CHECK_TICK
	var/took = REALTIMEOFDAY - timer
	to_chat(world, SPAN_DANGER("Migrated [.] savefiles in [round(took * 0.1, 0.1)] seconds."))
*/

