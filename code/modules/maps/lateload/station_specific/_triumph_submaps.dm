/datum/map_template/lateload/triumph/triumph_misc
	name = "Triumph - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = "maps/map_files/triumph/triumph_misc.dmm"

	associated_map_datum = /datum/map_level/triumph_lateload/ships

	ztraits = list()

/datum/map_level/triumph_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED

/datum/map_template/lateload/triumph/triumph_ships
	name = "Triumph - Ships"
	desc = "Ship transit map and whatnot."
	mappath = "maps/map_files/triumph/triumph_ships.dmm"

	associated_map_datum = /datum/map_level/triumph_lateload/ships

	ztraits = list()

/datum/map_level/triumph_lateload/ships
	name = "Ships"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED
