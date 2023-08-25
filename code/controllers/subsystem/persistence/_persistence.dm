//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	subsystem_flags = SS_NO_FIRE
	/// The directory to write to for per-map persistence. If null, the current map shouldn't be persisted to/from.
	var/current_map_directory
	/// current map id - used for database
	// var/current_map_id

/datum/controller/subsystem/persistence/Initialize()
	SetMapDirectory()
	LoadPersistence()
	return ..()

/datum/controller/subsystem/persistence/Shutdown()
	SavePersistence()
	return ..()

/**
  * Loads all persistent information from disk.
  */
/datum/controller/subsystem/persistence/proc/LoadPersistence()
	return

/**
  * Saves all persistent information to disk.
  */
/datum/controller/subsystem/persistence/proc/SavePersistence()
	return

/**
  * Sets our current_map_directory to corrospond to the current map.
  */
/datum/controller/subsystem/persistence/proc/SetMapDirectory()
	if(!SSmapping.loaded_station.legacy_persistence_id)
		return			// map doesn't support persistence.
	current_map_directory = "[PERSISTENCE_MAP_ROOT_DIRECTORY]/[SSmapping.loaded_station.legacy_persistence_id]"
