// This file MUST match what's in _mapload/basemap.dm for what .dmms are compiled in.

/**
 * Initializes the map levels for the base, compiled in maps. This MUST match with what's actually compiled in.
 */
/datum/controller/subsystem/mapping/proc/initialize_default_levels()
	create_reserved_level()

/**
 * since init order is fixed and things that go before this subsystem may require map config to be set we have to do this stupid proc :/
 */
/datum/controller/subsystem/mapping/proc/ensure_config_loaded()
	if(!map)
#ifdef FORCE_MAP
		load_world(FORCE_MAP)
#else
		load_world(get_next_map())
#endif
	stat_map_name = get_map_name()
