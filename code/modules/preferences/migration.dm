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


