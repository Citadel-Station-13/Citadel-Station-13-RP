//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Downstream-compatible migration system.
 */
/datum/character_migrater
	var/list/datum/character_migration/migrations

/datum/character_migrater/New()
	for(var/datum/character_migration/typepath as anything in subtypesof_non_abstract(/datum/character_migration))
		if(migrations[typepath.key])
			stack_trace("duplicate migration [typepath.key] key [typepath] vs [migrations[typepath.key]:type]")
			continue
		migrations[typepath.key] = new typepath

/**
 * @return TRUE success, FALSE on significant error
 */
/datum/character_migrater/proc/perform_migrations(datum/character/character, list/out_warnings, list/out_errors, list/out_keys_performed)
	if(!islist(character.s_migrations_performed))
		if(character.s_migrations_performed)
			out_errors?.Add("BUG: s_migrations_performed was somehow not a list?")
		character.s_migrations_performed = list()
	. = TRUE
	for(var/datum/character_migration/migration as anything in migrations)
		if(migration.key in character.s_migrations_performed)
			continue
		. = . && migration.perform(character, out_warnings, out_errors)
		out_keys_performed?.Add(migration.key)
