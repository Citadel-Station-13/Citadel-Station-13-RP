//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Manages character setup, character saving, loading,
 * and will eventually serve as the middleware
 * between character preferences and character
 * persistence as well.
 */
SUBSYSTEM_DEF(characters_new)
	name = "Characters (New)"
	init_order = INIT_ORDER_CHARACTERS
	subsystem_flags = SS_NO_FIRE

	//* System *//

	/// Initialized character storage backend.
	/// * Character storage is separate from the rest of the game's storage systems,
	///   so that it's isolated from any non-trivial fuckups.
	var/datum/character_backend/backend

/datum/controller/subsystem/characters/Initialize()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/characters/Recover()

#warn init backend
