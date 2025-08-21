//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// TODO: finish. Just stubs and prototype structure for now.

/**
 * used to migrate legacy characters to new system
 *
 * * This **will not** edit characters on the old system.
 * * This **will potentially**, but will try not to, trample characters in the new system.
 */
/datum/character_legacy_migrater
	var/datum/character_backend/backend

/**
 * @return characters migrated
 */
/datum/character_legacy_migrater/proc/migrate_ckey(ckey, list/out_errors)
	if(!pre_execute(out_errors))
		return 0
	#warn impl

/**
 * @return ckeys migrated
 */
/datum/character_legacy_migrater/proc/migrate_everyone(list/out_errors)
	if(!pre_execute(out_errors))
		return 0
	. = 0
	var/start_time = REALTIMEOFDAY
	to_chat(world, SPAN_BOLDANNOUNCE("Migrating all savefiles to new character system. Please avoid using character setup at this time."))
	var/list/relevant_paths = list()
	for(var/path in directory_walk(list("data/player_saves")))
		var/list/split_path = splittext_char(path, "/")
		if(!length(split_path) || split_path[length(split_path)] != "preferences.sav")
			continue
		relevant_paths[path] = split_path
	var/total_found = length(relevant_paths)
	var/total_characters_migrated = 0
	for(var/path in relevant_paths)
		var/list/split_path = relevant_paths[path]
		var/list/in_errors = list()
		var/their_ckey = split_path[length(split_path - 1)]
		total_characters_migrated += migrate_ckey(their_ckey, in_errors)
		#warn impl error handling
		++.
		if(!(. % 100))
			to_chat(world, SPAN_DANGER("...[. / relevant_paths] migrated, [total_characters_migrated] characters migrated. Please do not 'save' in character setup at this time."))
	var/end_time = REALTIMEOFDAY
	to_chat(world, SPAN_DANGER("Migrated [.] savefiles containing [total_characters_migrated] characters in [round((end_time - start_time) * 0.1, 0.1)] seconds."))



/datum/character_legacy_migrater/proc/pre_execute(list/out_errors)

/datum/character_legacy_migrater/proc/execute_on_ckey(ckey, list/out_errors)
	var/savefile_path = "data/player_saves/[copytext(ckey, 1, 3)]/[ckey]/preferences.sav"
	var/savefile/savefile = new savefile(savefile_path)

	#warn log?

	// you know what if you have more than 128 characters that's a you problem buddy friend pal
	for(var/i in 1 to 128)
		// NEW SYSTEM
		var/list/character_data
		var/character_version
		savefile["slot_[i]"] >> character_data
		if(!islist(character_data))
			#warn log?
			continue
		savefile.cd = "/character[i]"

		CRASH("unimplemented")

	#warn log?

/datum/character_legacy_migrater/proc/execute_on_ckey_character(ckey, list/char_data, savefile/sf_data, list/out_errors)
	if(!islist(char_data))
		#warn log?
		return

	var/datum/character/creating


#warn impl to some degree

