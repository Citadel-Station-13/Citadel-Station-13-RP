//////////////////////////////////////////////////////////////////////////////////////
// Code Shenanigans for Tether lateload maps
/datum/map_template/tether_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/tether_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(GLOB.using_map, z)

/datum/map_z_level/tether_lateload
	z = 0

/datum/map_z_level/tether_lateload/New(var/datum/map/map, mapZ)
	if(mapZ && !z)
		z = mapZ
	return ..(map)

///////////////////
/// Static Load ///
///////////////////

/datum/map_template/tether_lateload/tether_misc
	name = "Tether - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = "_maps/map_files/tether/tether_misc.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/misc

/datum/map_z_level/tether_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

/datum/map_template/tether_lateload/tether_underdark
	name = "Tether - Underdark"
	desc = "Mining, but harder."
	mappath = "_maps/map_files/tether/tether_underdark.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/underdark

/datum/map_z_level/tether_lateload/underdark
	name = "Underdark"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b

/datum/map_template/tether_lateload/tether_underdark/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 150, /area/mine/unexplored/underdark, /datum/map_template/submap/level_specific/underdark)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, z, 64, 64)         // Create the mining ore distribution map.

/datum/map_template/tether_lateload/tether_plains
	name = "Tether - Plains"
	desc = "The Virgo 3B away mission."
	mappath = "_maps/map_files/tether/tether_plains.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/tether_plains

/datum/map_z_level/tether_lateload/tether_plains
	name = "Away Mission - Plains"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b

/datum/map_template/tether_lateload/tether_plains/on_map_loaded(z)
 	. = ..()
 	seed_submaps(list(z), 150, /area/tether/outpost/exploration_plains, /datum/map_template/submap/level_specific/plains)


//////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////
// Gateway submaps go here

/obj/effect/overmap/visitable/sector/tether_gateway
	name = "Unknown"
	desc = "Approach and perform a scan to obtain further information."
	icon_state = "object" //or "globe" for planetary stuff
	known = FALSE

/datum/map_template/tether_lateload/gateway
	name = "Gateway Submap"
	desc = "Please do not use this."
	mappath = null
	associated_map_datum = null

/datum/map_z_level/tether_lateload/gateway_destination
	name = "Gateway Destination"

/datum/map_template/tether_lateload/gateway/snow_outpost
	name = "Snow Outpost"
	desc = "Big snowy area with various outposts."
	mappath = '_maps/away_missions/140x140/snow_outpost.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

/datum/map_template/tether_lateload/gateway/zoo
	name = "Zoo"
	desc = "Gigantic space zoo"
	mappath = '_maps/away_missions/140x140/zoo.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

/datum/map_template/tether_lateload/gateway/carpfarm
	name = "Carp Farm"
	desc = "Asteroid base surrounded by carp"
	mappath = '_maps/away_missions/140x140/carpfarm.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

/datum/map_template/tether_lateload/gateway/snowfield
	name = "Snow Field"
	desc = "An old base in middle of snowy wasteland"
	mappath = '_maps/away_missions/140x140/snowfield.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

/datum/map_template/tether_lateload/gateway/listeningpost
	name = "Listening Post"
	desc = "Asteroid-bound mercenary listening post"
	mappath = '_maps/away_missions/140x140/listeningpost.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/gateway_destination

//////////////////////////////////////////////////////////////////////////////////////
// Admin-use z-levels for loading whenever an admin feels like
/datum/map_template/tether_lateload/fun/spa
	name = "Space Spa"
	desc = "A pleasant spa located in a spaceship."
	mappath = '_maps/templates/admin/spa.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/fun/spa

/datum/map_z_level/tether_lateload/fun/spa
	name = "Spa"
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED

// Talon offmap spawn
/datum/map_template/tether_lateload/offmap/talon1
	name = "Offmap Ship - Talon Z1"
	desc = "Offmap spawn ship, the Talon."
	mappath = "_maps/map_levels/140x140/talon/talon1.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/talon1

/datum/map_template/tether_lateload/offmap/talon2
	name = "Offmap Ship - Talon Z2"
	desc = "Offmap spawn ship, the Talon."
	mappath = "_maps/map_levels/140x140/talon/talon2.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/talon2

/datum/map_z_level/tether_lateload/talon1
	name = "Talon Deck One"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/space

/datum/map_z_level/tether_lateload/talon2
	name = "Talon Deck Two"
	flags = MAP_LEVEL_PLAYER
	base_turf = /turf/simulated/open
