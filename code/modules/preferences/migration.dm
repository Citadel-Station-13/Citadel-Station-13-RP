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
		S["alternate_option"]	>> alternate_option
		S["job_civilian_high"]	>> job_civilian_high
		S["job_civilian_med"]	>> job_civilian_med
		S["job_civilian_low"]	>> job_civilian_low
		S["job_medsci_high"]	>> job_medsci_high
		S["job_medsci_med"]		>> job_medsci_med
		S["job_medsci_low"]		>> job_medsci_low
		S["job_engsec_high"]	>> job_engsec_high
		S["job_engsec_med"]		>> job_engsec_med
		S["job_engsec_low"]		>> job_engsec_low
		S["job_talon_low"]		>> job_talon_low
		S["job_talon_med"]		>> job_talon_med
		S["job_talon_high"]		>> job_talon_high
		S["player_alt_titles"]	>> player_alt_titles
		var/list/assembled = list()
		var/list/assembled_titles = list()
		if(!islist(player_alt_titles))
			player_alt_titles = list()
		for(var/datum/job/J as anything in SSjob.occupations)
			switch(J.department)
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
		switch(alternate_option)
			if(0)
				overflow = JOB_ALTERNATIVE_GET_RANDOM
			if(1)
				overflow = JOB_ALTERNATIVE_BE_ASSISTANT
			if(2)
				overflow = JOB_ALTERNATIVE_RETURN_LOBBY
		character[CHARACTER_DATA_JOBS] = assembled
		character[CHARACTER_DATA_OVERFLOW_MODE] = overflow
		character[CHARACTER_DATA_ALT_TITLES] = assembleD_titles
		// BACKGROUNDS: NOT MIGRATED
		// MIGRATE SPECIES

		#warn impl all
		// MIGRATE LANGUAGES


