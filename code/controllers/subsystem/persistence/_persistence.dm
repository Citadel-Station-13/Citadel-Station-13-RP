//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	subsystem_flags = SS_NO_FIRE
	/// The directory to write to for per-map persistence. If null, the current map shouldn't be persisted to/from.
	var/current_map_directory
	/// current map id - used for database
	var/current_map_id

/datum/controller/subsystem/persistence/Initialize()
	SetMapDirectory()
	InitPersistence()
	LoadPersistence()
	return ..()

/datum/controller/subsystem/persistence/Shutdown()
	SavePersistence()
	return ..()

/datum/controller/subsystem/persistence/Recover()
	. = ..()
	SetMapDirectory()
	InitPersistence()

/**
 * first pass: create all singletons necessary for operation
 *
 * called on initialization **and** recovery. make sure everything is recreated if necessary.
 */
/datum/controller/subsystem/persistence/proc/InitPersistence()
	return

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
	if(!SSmapping.config.persistence_id)
		current_map_id = null
		current_map_directory = null
		return			// map doesn't support persistence.
	current_map_id = ckey(SSmapping.config.persistence_id)
	current_map_directory = "[PERSISTENCE_MAP_ROOT_DIRECTORY]/[current_map_id]"

#warn impl

/**
 * gets ID of host map datum
 *
 * you usually want level_id_of_z instead.
 */
/datum/controller/subsystem/persistence/proc/map_id_of_z(z)
	#warn impl

/**
 * gets ID of level
 */
/datum/controller/subsystem/persistence/proc/level_id_of_z()
	#warn impl
