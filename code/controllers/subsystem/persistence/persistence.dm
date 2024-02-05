//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	#warn bump init order
	init_order = INIT_ORDER_PERSISTENCE
	subsystem_flags = SS_NO_FIRE

	/// world already loaded?
	var/static/loaded_persistent_world = FALSE

/datum/controller/subsystem/persistence/Initialize()
	#warn stuff
	InitPersistence()
	LoadPersistence()
	return ..()

/datum/controller/subsystem/persistence/Shutdown()
	#warn stuff
	SavePersistence()
	return ..()

/datum/controller/subsystem/persistence/Recover()
	. = ..()
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

//* ID Mapping *//

/**
 * gets ID of host map datum
 *
 * you usually want level_id_of_z instead.
 */
/datum/controller/subsystem/persistence/proc/map_id_of_z(z)
	return SSmapping.ordered_levels[z]?.parent_map

/**
 * gets ID of level
 */
/datum/controller/subsystem/persistence/proc/level_id_of_z(z)
	return SSmapping.level_id(z)
