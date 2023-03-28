/**
 *! Unique Map Templates
 *? This is for maps that are not overmap accessible but are also not gateway maps. There shouldn't be much of these right now
 *? unless a large shift in design philosophy occurs
 */

////////////////////////////////////////////////////////
/// Lava Land - Otherwise known as Surt or something ///
////////////////////////////////////////////////////////

/datum/map_template/lateload/unique/lavaland
	name = "Away Mission - Lava Land"
	desc = "The fabled."
	mappath = "maps/map_levels/192x192/lavaland.dmm"
	associated_map_datum = /datum/map_z_level/unique_lateload/lavaland
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_z_level/unique_lateload/lavaland
	name = "Away Mission - Lava Land"
	base_turf = /turf/simulated/mineral/floor/lavaland

/datum/map_template/lateload/unique/lavaland/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 40, /area/lavaland/central/unexplored, /datum/map_template/submap/level_specific/lavaland)
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, z, 64, 64)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z, world.maxx - 4, world.maxy - 4) // Create the lavaland Z-level.

/*

////////////////////////////////////////////////////////
/// Lava Land - Event Dungeon						 ///
////////////////////////////////////////////////////////

// This one is not permanent. Comment this out once it's done.
/datum/map_template/lateload/unique/lavaland_dungeon
	name = "Away Mission - Lava Land (Dungeon)"
	desc = "The flooded."
	mappath = "maps/map_levels/192x192/lavaland_dungeon.dmm"
	associated_map_datum = /datum/map_z_level/unique_lateload/lavaland_dungeon
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_z_level/unique_lateload/lavaland_dungeon
	name = "Away Mission - Lava Land (Dungeon)"

/datum/map_template/lateload/unique/lavaland_dungeon/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 0, /area/lavaland/east/unexplored, /datum/map_template/submap/level_specific/lavaland)
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, z, 64, 64)
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z, world.maxx - 4, world.maxy - 4)
*/

////////////////////////////////////////////////////////
/// Lava Land - East								 ///
////////////////////////////////////////////////////////

/datum/map_template/lateload/unique/lavaland_east
	name = "Away Mission - Lava Land (East)"
	desc = "The forgotten."
	mappath = "maps/map_levels/192x192/lavaland_east.dmm"
	associated_map_datum = /datum/map_z_level/unique_lateload/lavaland_east
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_z_level/unique_lateload/lavaland_east
	name = "Away Mission - Lava Land (East)"
	base_turf = /turf/simulated/mineral/floor/lavaland

/datum/map_template/lateload/unique/lavaland_east/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 0, /area/lavaland/east/unexplored, /datum/map_template/submap/level_specific/lavaland)
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, z, 64, 64)
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z, world.maxx - 4, world.maxy - 4)

/obj/landmark/map_data/lavaland_east
	height = 1
