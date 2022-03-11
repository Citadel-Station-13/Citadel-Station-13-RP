SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE
	/// The directory to write to for per-map persistence. If null, the current map shouldn't be persisted to/from.
	var/current_map_directory

/datum/controller/subsystem/persistence/Initialize()

/datum/controller/subsystem/persistence/Shutdown()
