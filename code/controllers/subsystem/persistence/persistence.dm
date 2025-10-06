//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// todo: tgui system panel

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	subsystem_flags = SS_NO_FIRE

	/// world already loaded?
	var/static/world_loaded = FALSE
	/// world saved how many times?
	var/static/world_saved_count = 0
	/// world load in progress; block.
	var/static/world_serialization_mutex = FALSE
	/// world is non-canon; do not save world automatically
	//  todo: interface on subsystem panel
	var/static/world_non_canon = FALSE

	/// prototype id to typepath
	var/list/prototype_id_to_path

/datum/controller/subsystem/persistence/Initialize()
	/// build prototype lookup list
	build_prototype_id_lookup()
	LoadPersistence()
	// todo: should this be here? save_the_world is in ticker.
	if(CONFIG_GET(flag/persistence))
		load_the_world()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/persistence/Shutdown()
	SavePersistence()
	return ..()

/**
  * Loads all persistent information from disk.
  */
/datum/controller/subsystem/persistence/proc/LoadPersistence()
	LoadPanicBunker()

/**
  * Saves all persistent information to disk.
  */
/datum/controller/subsystem/persistence/proc/SavePersistence()
	SavePanicBunker()

//* ID Mapping *//

/**
 * gets ID of host map datum
 *
 * you usually want level_id_of_z instead.
 *
 * @return null if map shouldn't persist (levels under it still can!! careful!!), otherwise map id for persistence
 */
/datum/controller/subsystem/persistence/proc/map_id_of_z(z)
	var/datum/map/map = SSmapping.ordered_levels[z]?.parent_map
	return map?.id

/**
 * gets ID of level
 *
 * @return null if level shouldn't persist, otherwise level id for persistence
 */
/datum/controller/subsystem/persistence/proc/level_id_of_z(z)
	var/datum/map_level/level = SSmapping.ordered_levels[z]
	return level.persistence_allowed? (level.persistence_id || level.id) : null
