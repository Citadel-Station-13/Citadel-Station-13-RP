/**
 *! Overmap Space Templates
 *? This is for objects in space that are accessible from the overmap.
 */

//////////////////
/// Tradepord  ///
//////////////////

/datum/map_template/lateload/space/away_tradeport
	name = "Away Mission - Trade Port"
	desc = "A space gas station! Stretch your legs!"
	mappath = "_maps/map_levels/192x192/tradeport.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/away_tradeport
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = FALSE)

/datum/map_z_level/space_lateload/away_tradeport
	name = "Away Mission - Trade Port"
	base_turf = /turf/space


//////////////////
/// Debri Field///
//////////////////

/datum/map_template/lateload/space/away_debrisfield
	name = "Debris Field - Z1 Space"
	desc = "A random debris field out in space."
	mappath = "_maps/map_levels/192x192/debrisfield.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/away_debrisfield


/datum/map_template/lateload/space/away_debrisfield/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 200, /area/space/debrisfield/unexplored, /datum/map_template/submap/level_specific/debrisfield)

/datum/map_z_level/space_lateload/away_debrisfield
	name = "Away Mission - Debris Field"
	base_turf = /turf/space

///////////////////////
/// Pirate Base ///
///////////////////////

/datum/map_template/lateload/space/away_piratebase
	name = "Away Mission - Pirate Base"
	desc = "A Pirate Base, oh no!"
	mappath = "_maps/map_levels/192x192/piratebase.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/away_piratebase
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = FALSE)

/datum/map_z_level/space_lateload/away_piratebase
	name = "Away Mission - Pirate Base"
	base_turf = /turf/space


//////////////////////////
//   Fuel Depot        ///
//////////////////////////


/datum/map_template/lateload/space/away_fueldepot
	name = "Fuel Depot - Z1 Space"
	desc = "An unmanned fuel depot floating in space."
	mappath = '_maps/map_levels/140x140/fueldepot.dmm'
	associated_map_datum = /datum/map_z_level/space_lateload/away_fueldepot

/datum/map_z_level/space_lateload/away_fueldepot
	name = "Away Mission - Fuel Depot"

//////////////////////////
//Asteroid belter stuff///
//////////////////////////

/datum/map_template/lateload/space/roguemines1
	name = "Asteroid Belt 1"
	desc = "Mining, but rogue. Zone 1"
	mappath = "_maps/map_levels/192x192/roguemining_192x192/rogue_mine1.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/roguemines1

/datum/map_z_level/space_lateload/roguemines1
	name = "Belt 1"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER

/datum/map_template/lateload/space/roguemines2
	name = "Asteroid Belt 2"
	desc = "Mining, but rogue. Zone 2"
	mappath = "_maps/map_levels/192x192/roguemining_192x192/rogue_mine2.dmm"

	associated_map_datum = /datum/map_z_level/space_lateload/roguemines2

/datum/map_z_level/space_lateload/roguemines2
	name = "Belt 2"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER

/datum/map_template/lateload/space/roguemines3
	name = "Asteroid Belt 3"
	desc = "Mining, but rogue. Zone 3"
	mappath = "_maps/map_levels/192x192/roguemining_192x192/rogue_mine3.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/roguemines3

/datum/map_z_level/space_lateload/roguemines3
	name = "Belt 3"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER


/datum/map_template/lateload/space/roguemines4
	name = "Asteroid Belt 4"
	desc = "Mining, but rogue. Zone 4"
	mappath = "_maps/map_levels/192x192/roguemining_192x192/rogue_mine4.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/roguemines1

/datum/map_z_level/space_lateload/roguemines4
	name = "Belt 4"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER

//////////////////////////
// Alien Ship          ///
//////////////////////////

/datum/map_template/lateload/space/away_alienship
	name = "Alien Ship - Z1 Ship"
	desc = "The alien ship away mission."
	mappath = "_maps/map_levels/140x140/alienship.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/away_alienship

/datum/map_z_level/space_lateload/away_alienship
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
	mappath = "_maps/map_levels/140x140/talon/talon1.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/talon1

/datum/map_template/lateload/space/offmap/talon2
	name = "Offmap Ship - Talon Z2"
	desc = "Offmap spawn ship, the Talon."
	mappath = "_maps/map_levels/140x140/talon/talon2.dmm"
	associated_map_datum = /datum/map_z_level/space_lateload/talon2

/datum/map_z_level/space_lateload/talon1
	name = "Talon Deck One"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/space

/datum/map_z_level/space_lateload/talon2
	name = "Talon Deck Two"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/open

