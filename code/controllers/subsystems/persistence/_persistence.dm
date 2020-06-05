SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE
	/// The directory to write to for per-map persistence. If null, the current map shouldn't be persisted to/from.
	var/current_map_directory

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
	if(!SSmapping.config.persistence_id)
		return			// map doesn't support persistence.
	current_map_directory = "[PERSISTENCE_MAP_ROOT_DIRECTORY]/[SSmapping.config.persistence_id]"
