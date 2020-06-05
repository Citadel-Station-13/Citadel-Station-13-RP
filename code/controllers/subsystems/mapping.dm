// Handles map-related tasks, mostly here to ensure it does so after the MC initializes.
SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	/// The current map config datum the round is using
	var/datum/map_config/config
	/// The next map to load
	var/datum/map_config/next_map_config

	/// Cached map name for statpanel
	var/stat_map_name = "Loading..."

	/// Lookup list for random generated IDs.
	var/list/random_generated_ids_by_original = list()
	/// next id for separating obfuscated ids.
	var/obfuscation_next_id = 1
	/// "secret" key
	var/obfuscation_secret

//dlete dis once #39770 is resolved
/datum/controller/subsystem/mapping/proc/HACK_LoadMapConfig()
	if(!config)
#ifdef FORCE_MAP
		config = load_map_config(FORCE_MAP)
#else
		config = load_map_config(error_if_missing = FALSE)
#endif
	stat_map_name = config.map_name

/datum/controller/subsystem/mapping/PreInit()
	if(!obfuscation_secret)
		obfuscation_secret = md5(GUID())		//HAH! Guess this!

/datum/controller/subsystem/mapping/Initialize(timeofday)
	HACK_LoadMapConfig()
	if(subsystem_initialized)
		return
	if(config.defaulted)
		var/old_config = config
		config = global.config.defaultmap
		if(!config || config.defaulted)
			to_chat(world, "<span class='boldannounce'>Unable to load next or default map config, defaulting to Tethermap</span>")
			config = old_config
