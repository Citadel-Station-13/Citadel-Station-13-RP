/datum/map_injection/legacy_noise_ores
	var/seed
	var/deep_val = 0.8
	var/rare_val = 0.7

/datum/map_injection/legacy_noise_ores/New(seed, deep_val, rare_val)
	..()
	if(!isnull(seed))
		src.seed = seed
	if(!isnull(deep_val))
		src.deep_val = deep_val
	if(!isnull(rare_val))
		src.rare_val = rare_val

/datum/map_injection/legacy_noise_ores/on_entire_z_of_dmm

/datum/map_injection/legacy_noise_ores/on_entire_z_of_dmm/on_map_pre_init(datum/map_context/map_context, datum/dmm_context/dmm_context)
	..()

	if(!dmm_context)
		return

	if(dmm_context.loaded_bounds[MAP_MINZ] != dmm_context.loaded_bounds[MAP_MAXZ])
		CRASH("legacy_noise_ores only supports injection on a single Z-level at a time")

	// TODO: this only goes up to 256x256 due to internal limitations of the chunk size and limits.
	new /datum/random_map/noise/ore(null, 1, 1, dmm_context.loaded_bounds[MAP_MINZ], 64, 64)
