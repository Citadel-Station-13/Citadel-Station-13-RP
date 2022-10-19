/**
 * @params
 * - S - the savefile we operate on
 * - current_version - the version it's at
 * - errors - put errors into this list to be displayed to the player
 * - options - the loaded global options list
 */
/datum/preferences/proc/perform_global_migrations(savefile/S, current_version, list/errors, list/options)
	if(savefile_version < 13)
		addtimer(CALLBACK(src, .proc/force_reset_keybindings), 5 SECONDS)

/**
 * @params
 * - S - the savefile we operate on
 * - current_version - the version it's at
 * - errors - put errors into this list to be displayed to the player
 * - options - the loaded character options list
 */
/datum/preferences/proc/perform_character_migrations(savefile/S, current_version, list/errors, list/character)
	if(savefile_version < 1)
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
		var/player_alt_titles
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
		for(var/datum/job/J as anything in SSjob.occupations)
			switch(J.department)
				if(CIVILIAN)

				if(MEDSCI)

				if(ENGSEC)



