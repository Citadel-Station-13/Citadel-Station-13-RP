// This causes triumph submap maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.

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

//////////////////////////////////////////////////////////////////////////////
/// Away Missions

// Debris Fields
#include "space/_debrisfield.dm"
/datum/map_template/triumph_lateload/away_debrisfield
	name = "Debris Field - Z1 Space"
	desc = "A random debris field out in space."
	mappath = "_maps/planet_levels/140x140/debrisfield.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_debrisfield
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = FALSE)

/datum/map_z_level/triumph_lateload/away_debrisfield
	name = "Away Mission - Debris Field"
	z = Z_LEVEL_DEBRISFIELD


/datum/map_template/triumph_lateload/away_debrisfield/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_DEBRISFIELD), 125, /area/space/debrisfield/unexplored, /datum/map_template/submap/level_specific/debrisfield)

// Pirate base
#include "space/_piratebase.dm"

/datum/map_template/triumph_lateload/away_piratebase
	name = "Away Mission - Pirate Base"
	desc = "A Vox Marauder Base, oh no!"
	mappath = "_maps/planet_levels/140x140/piratebase.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_piratebase
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = FALSE)

/datum/map_z_level/triumph_lateload/away_piratebase
	name = "Away Mission - Pirate Base"
	z = Z_LEVEL_PIRATEBASE

// Mining Planet
#include "mining_planet/_miningplanet.dm"

/datum/map_template/triumph_lateload/away_mining_planet
	name = "Away Mission - Mining Planet"
	desc = "Mining Plante. For the miners to get actual supplies."
	mappath = "_maps/planet_levels/140x140/mining_planet.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_mining_planet
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_z_level/triumph_lateload/away_mining_planet
	name = "Away Mission - Mining Planet"
	z = Z_LEVEL_MININGPLANET

/datum/map_template/triumph_lateload/away_mining_planet/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_MININGPLANET, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore/mining_planet(null, 1, 1, Z_LEVEL_MININGPLANET, 64, 64)         // Create the mining ore distribution map.

// lavaland start
#include "lavaland/_lavaland.dm"
/datum/map_template/triumph_lateload/lavaland
	name = "Away Mission - Lava Land"
	desc = "The fabled."
	mappath = "_maps/planet_levels/140x140/lavaland.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/lavaland
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_z_level/triumph_lateload/lavaland
	name = "Away Mission - Lava Land"
	z = Z_LEVEL_LAVALAND

/datum/map_template/triumph_lateload/lavaland/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_LAVALAND), 40, /area/lavaland/unexplored, /datum/map_template/submap/level_specific/lavaland)
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, Z_LEVEL_LAVALAND, 64, 64)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_LAVALAND, world.maxx - 4, world.maxy - 4) // Create the lavaland Z-level.


// Class D Rogue Planet Exploration Zone.
/datum/map_template/triumph_lateload/away_d_world
	name = "ExoPlanet - Z1 Planet"
	desc = "A random unknown planet."
	mappath = "_maps/planet_levels/140x140/Class_D.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_d_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/triumph_lateload/away_d_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_UNKNOWN_PLANET), 150, /area/poi_d/unexplored, /datum/map_template/submap/level_specific/class_d)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/triumph_lateload/away_d_world
	name = "Away Mission - Rogue Planet"
	z = Z_LEVEL_UNKNOWN_PLANET

// Class H Desert Planet Exploration Zone.
/datum/map_template/triumph_lateload/away_h_world
	name = "ExoPlanet - Z2 Planet"
	desc = "A random unknown planet."
	mappath = "_maps/planet_levels/140x140/Class_H.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_h_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/triumph_lateload/away_h_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_DESERT_PLANET), 150, /area/poi_h/unexplored, /datum/map_template/submap/level_specific/class_h)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/triumph_lateload/away_h_world
	name = "Away Mission - Desert Planet"
	z = Z_LEVEL_DESERT_PLANET

// Gaia Planet Zone.
/datum/map_template/triumph_lateload/gaia_planet
	name = "Gaia Planet - Z3 Planet"
	desc = "A lush Gaia Class Planet."
	mappath = "_maps/planet_levels/140x140/gaia_planet.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/gaia_planet
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/triumph_lateload/gaia_planet/on_map_loaded(z)
	. = ..()
//	seed_submaps(list(Z_LEVEL_DESERT_PLANET), 150, /area/poi_h/unexplored, /datum/map_template/submap/level_specific/class_h)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/triumph_lateload/gaia_planet
	name = "Away Mission - Gaia Planet"
	z = Z_LEVEL_GAIA_PLANET


// Frozen Planet Zone.
/datum/map_template/triumph_lateload/frozen_planet
	name = "Forzen Planet - Z4 Planet"
	desc = "A Cold Frozen Planet."
	mappath = "_maps/planet_levels/140x140//frozen_planet.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/frozen_planet
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/triumph_lateload/frozen_planet/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_FROZEN_PLANET), 125, /area/frozen_planet/ruins, /datum/map_template/submap/level_specific/frozen_planet)


/datum/map_z_level/triumph_lateload/frozen_planet
	name = "Away Mission - Frozen Planet"
	z = Z_LEVEL_FROZEN_PLANET

// Trade post
#include "space/trade_port/_tradeport.dm"

/datum/map_template/triumph_lateload/away_tradeport
	name = "Away Mission - Trade Port"
	desc = "A space gas station! Stretch your legs!"
	mappath = "_maps/planet_levels/140x140/tradeport.dmm"
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_tradeport
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = FALSE)

/datum/map_z_level/triumph_lateload/away_tradeport
	name = "Away Mission - Trade Port"
	z = Z_LEVEL_TRADEPORT

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

/turf/unsimulated/wall/seperator //to block vision between transit zones
	name = ""
	icon = 'icons/effects/effects.dmi'
	icon_state = "1"

/obj/effect/step_trigger/zlevel_fall //Don't ever use this, only use subtypes.Define a new var/static/target_z on each
	var/static/target_z
	affect_ghosts = 1

/obj/effect/step_trigger/zlevel_fall/Initialize(mapload)
	. = ..()

	if(istype(get_turf(src), /turf/simulated/floor))
		src:target_z = z
		return INITIALIZE_HINT_QDEL

/obj/effect/step_trigger/zlevel_fall/Trigger(var/atom/movable/A) //mostly from /obj/effect/step_trigger/teleporter/planetary_fall, step_triggers.dm L160
	if(!src:target_z)
		return

	var/attempts = 100
	var/turf/simulated/T
	while(attempts && !T)
		var/turf/simulated/candidate = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),src:target_z)
		if(candidate.density)
			attempts--
			continue

		T = candidate
		break

	if(!T)
		return

	if(isobserver(A))
		A.forceMove(T) // Harmlessly move ghosts.
		return

	A.forceMove(T)
	if(isliving(A)) // Someday, implement parachutes.  For now, just turbomurder whoever falls.
		message_admins("\The [A] fell out of the sky.")
		var/mob/living/L = A
		L.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.

//// MINING LEVELS
/datum/map_template/triumph_lateload/roguemines1
	name = "Asteroid Belt 1"
	desc = "Mining, but rogue. Zone 1"
	mappath = "_maps/planet_levels/140x140/roguemining/rogue_mine1.dmm"

	associated_map_datum = /datum/map_z_level/triumph_lateload/roguemines1

/datum/map_z_level/triumph_lateload/roguemines1
	name = "Belt 1"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_1

/datum/map_template/triumph_lateload/tether_roguemines2
	name = "Asteroid Belt 2"
	desc = "Mining, but rogue. Zone 2"
	mappath = "_maps/planet_levels/140x140/roguemining/rogue_mine2.dmm"

	associated_map_datum = /datum/map_z_level/triumph_lateload/roguemines2

/datum/map_z_level/triumph_lateload/roguemines2
	name = "Belt 2"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_2

/datum/map_template/triumph_lateload/tether_roguemines3
	name = "Asteroid Belt 3"
	desc = "Mining, but rogue. Zone 3"
	mappath = "_maps/planet_levels/140x140/roguemining/rogue_mine3.dmm"

	associated_map_datum = /datum/map_z_level/triumph_lateload/roguemines3

/datum/map_z_level/triumph_lateload/roguemines3
	name = "Belt 3"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_3

/datum/map_template/triumph_lateload/tether_roguemines4
	name = "Asteroid Belt 4"
	desc = "Mining, but rogue. Zone 4"
	mappath = "_maps/planet_levels/140x140/roguemining/rogue_mine4.dmm"

	associated_map_datum = /datum/map_z_level/triumph_lateload/roguemines4

/datum/map_z_level/triumph_lateload/roguemines4
	name = "Belt 4"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_4
