/**
 *! Overmap Space Templates
 *? This is for objects in space that are accessible from the overmap.
 */


//////////////////////////
//   Fuel Depot        ///
//////////////////////////


/datum/map_template/lateload/space/away_fueldepot
	name = "Fuel Depot - Z1 Space"
	desc = "An unmanned fuel depot floating in space."
	map_path = 'maps/map_levels/140x140/fueldepot.dmm'
	associated_map_datum = /datum/map_level/space_lateload/away_fueldepot

/datum/map_level/space_lateload/away_fueldepot
	name = "Away Mission - Fuel Depot"


//////////////////////////
// Alien Ship          ///
//////////////////////////

/datum/map_template/lateload/space/away_alienship
	name = "Alien Ship - Z1 Ship"
	desc = "The alien ship away mission."
	map_path = "maps/map_levels/140x140/alienship.dmm"
	associated_map_datum = /datum/map_level/space_lateload/away_alienship

/datum/map_level/space_lateload/away_alienship
	name = "Away Mission - Alien Ship"



//////////////////////////
/// Talon Ship         ///
//////////////////////////
/*
Not sure if this will work properly but no reason to get rid of it right now
*/
/datum/map_template/lateload/space/offmap/talon1
	name = "Offmap Ship - Talon Z1"
	desc = "Offmap spawn ship, the Talon."
	map_path = "maps/map_levels/140x140/talon/talon1.dmm"
	associated_map_datum = /datum/map_level/space_lateload/talon1

/datum/map_template/lateload/space/offmap/talon2
	name = "Offmap Ship - Talon Z2"
	desc = "Offmap spawn ship, the Talon."
	map_path = "maps/map_levels/140x140/talon/talon2.dmm"
	associated_map_datum = /datum/map_level/space_lateload/talon2

/datum/map_level/space_lateload/talon1
	name = "Talon Deck One"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/space

/datum/map_level/space_lateload/talon2
	name = "Talon Deck Two"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/open
