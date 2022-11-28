//////////////////////////////////////////////////////////////////////////////////////
// Code Shenanigans for Triumph lateload maps
/datum/map_template/triumph_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/triumph_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(GLOB.using_map, z)

/datum/map_z_level/triumph_lateload
	z = 0
	flags = MAP_LEVEL_SEALED

/datum/map_z_level/triumph_lateload/New(var/datum/map/map, mapZ)
	if(mapZ && !z)
		z = mapZ
	return ..(map)



//////////////////////////////////////////////////////////////////////////////
/// Static Load
/datum/map_template/triumph_lateload/triumph_misc
	name = "Triumph - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = "_maps/map_files/triumph/triumph_misc.dmm"

	associated_map_datum = /datum/map_z_level/triumph_lateload/ships

	ztraits = list()

/datum/map_z_level/triumph_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED

/datum/map_template/triumph_lateload/triumph_ships
	name = "Triumph - Ships"
	desc = "Ship transit map and whatnot."
	mappath = "_maps/map_files/triumph/triumph_ships.dmm"

	associated_map_datum = /datum/map_z_level/triumph_lateload/ships

	ztraits = list()

/datum/map_z_level/triumph_lateload/ships
	name = "Ships"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED
