
#define Z_LEVEL_ROGUEMINE_1					19
#define Z_LEVEL_ROGUEMINE_2					20
#define Z_LEVEL_ROGUEMINE_3					21
#define Z_LEVEL_ROGUEMINE_4					22

/datum/map_template/tether_lateload/tether_roguemines1
	name = "ZAsteroid Belt 1"
	desc = "Mining, but rogue. Zone 1"
	mappath = 'rogue_mines/rogue_mine1.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines1

/datum/map_z_level/tether_lateload/roguemines1
	name = "Belt 1"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_1

/datum/map_template/tether_lateload/tether_roguemines2
	name = "ZAsteroid Belt 2"
	desc = "Mining, but rogue. Zone 2"
	mappath = 'rogue_mines/rogue_mine2.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines2

/datum/map_z_level/tether_lateload/roguemines2
	name = "Belt 2"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_2

/datum/map_template/tether_lateload/tether_roguemines3
	name = "ZAsteroid Belt 3"
	desc = "Mining, but rogue. Zone 3"
	mappath = 'rogue_mines/rogue_mine3.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines3

/datum/map_z_level/tether_lateload/roguemines3
	name = "Belt 3"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_3

/datum/map_template/tether_lateload/tether_roguemines4
	name = "ZAsteroid Belt 4"
	desc = "Mining, but rogue. Zone 4"
	mappath = 'rogue_mines/rogue_mine4.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines4

/datum/map_z_level/tether_lateload/roguemines4
	name = "Belt 4"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_4