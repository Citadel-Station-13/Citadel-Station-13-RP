/datum/map_template/lateload/tether/tether_misc
	name = "Tether - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = "maps/map_files/tether/tether_misc.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/misc

/datum/map_z_level/tether_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_template/lateload/tether/tether_underdark
	name = "Tether - Underdark"
	desc = "Mining, but harder."
	mappath = "maps/map_files/tether/tether_underdark.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/underdark

/datum/map_z_level/tether_lateload/underdark
	name = "Underdark"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b

/datum/map_template/lateload/tether/tether_underdark/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 150, /area/mine/unexplored/underdark, /datum/map_template/submap/level_specific/underdark)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)         // Create the mining ore distribution map.

/datum/map_template/lateload/tether/tether_plains
	name = "Tether - Plains"
	desc = "The Virgo 3B away mission."
	mappath = "maps/map_files/tether/tether_plains.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/tether_plains

/datum/map_z_level/tether_lateload/tether_plains
	name = "Away Mission - Plains"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b

/datum/map_template/lateload/tether/tether_plains/on_map_loaded(z)
 	. = ..()
 	seed_submaps(list(z), 150, /area/tether/outpost/exploration_plains, /datum/map_template/submap/level_specific/plains)


