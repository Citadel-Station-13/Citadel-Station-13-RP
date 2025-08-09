/datum/world_init_options
	/**
	 * If enabled, will force only loading the given station map and nothing else.
	 * * The station map is still allowed to load 'required' dependency maps, but optionals
	 *   and overmaps should not load.
	 */
	var/load_only_station = FALSE

/datum/world_init_options/New()
	#ifdef FASTBOOT_DISABLE_LATELOAD
	load_only_station = TRUE
	#endif
