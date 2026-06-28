/datum/map_injection/legacy_automata_caves
	var/seed

/datum/map_injection/legacy_automata_caves/New(seed)
	..()
	if(!isnull(seed))
		src.seed = seed

/datum/map_injection/legacy_automata_caves/on_dmm/on_map_pre_init(datum/map_context/map_context, datum/dmm_context/dmm_context)
	..()

	if(!dmm_context)
		return

	for(var/z in dmm_context.loaded_bounds[MAP_MINZ] to dmm_context.loaded_bounds[MAP_MAXZ])
		new /datum/random_map/automata/cave_system(
			seed,
			dmm_context.loaded_bounds[MAP_MINX],
			dmm_context.loaded_bounds[MAP_MINY],
			z,
			dmm_context.loaded_bounds[MAP_MAXX],
			dmm_context.loaded_bounds[MAP_MAXY],
		)
