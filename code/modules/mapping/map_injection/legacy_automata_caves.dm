/datum/map_injection/legacy_automata_caves
	var/seed

/datum/map_injection/legacy_automata_caves/New(seed)
	src.seed = seed
	..()

/datum/map_injection/legacy_automata_caves/on_dmm/on_map_pre_init(datum/map_context/map_context, datum/dmm_context/dmm_context)
	..()
	new /datum/random_map/automata/cave_system

	. = list()
	for(var/z in dmm_context.loaded_bounds[MAP_MINZ] to dmm_context.loaded_bounds[MAP_MAXZ])
		. += z
