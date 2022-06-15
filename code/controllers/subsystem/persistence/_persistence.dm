SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	subsystem_flags = SS_NO_FIRE
	/// The directory to write to for per-map persistence. If null, the current map shouldn't be persisted to/from.
	var/current_map_directory

/datum/controller/subsystem/persistence/Initialize()
	SetMapDirectory()
	LoadServerPersistence()
	LoadMapPersistence()
	return ..()

/datum/controller/subsystem/persistence/Shutdown()
	SaveServerPersistence()
	SaveMapPersistence()
	return ..()

/**
  * Loads all globally persistent information from disk.
  */
/datum/controller/subsystem/persistence/proc/LoadServerPersistence()
	return

/**
  * Saves all globally persistent information to disk.
  */
/datum/controller/subsystem/persistence/proc/SaveServerPersistence()
	return

/**
  * Loads all persistent information relevant to a specific map from disk.
  */
/datum/controller/subsystem/persistence/proc/LoadMapPersistence()
	return

/**
  * Saves all persistent information relevant to a specific map to disk.
  */
/datum/controller/subsystem/persistence/proc/SaveMapPersistence()
	return

/**
  * Sets our current_map_directory to corrospond to the current map.
  */
/datum/controller/subsystem/persistence/proc/SetMapDirectory()
	if(!SSmapping.config.persistence_id)
		return			// map doesn't support persistence.
	current_map_directory = "[PERSISTENCE_MAP_ROOT_DIRECTORY]/[SSmapping.config.persistence_id]"
