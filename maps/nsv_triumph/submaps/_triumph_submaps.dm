// This causes triumph submap maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.

//////////////////////////////////////////////////////////////////////////////
/// Static Load
/datum/map_template/triumph_lateload/triumph_misc
	name = "Triumph - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = 'triumph_misc.dmm'

	associated_map_datum = /datum/map_z_level/triumph_lateload/ships

	ztraits = list()

/datum/map_z_level/triumph_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED

/datum/map_template/triumph_lateload/triumph_ships
	name = "Triumph - Ships"
	desc = "Ship transit map and whatnot."
	mappath = 'triumph_ships.dmm'

	associated_map_datum = /datum/map_z_level/triumph_lateload/ships

	ztraits = list()

/datum/map_z_level/triumph_lateload/ships
	name = "Ships"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED

//////////////////////////////////////////////////////////////////////////////
/// Away Missions
#if AWAY_MISSION_TEST
#include "space/debrisfield.dmm"
#include "space/piratebase.dmm"
#include "mining_planet/mining_planet.dmm"
#include "poi_d/Class_D.dmm"
#include "poi_h/Class_H.dmm"
#include "frozen_planet/frozen_planet.dmm"
#include "space/trade_port/tradeport.dmm"
#include "lavaland/lavaland.dmm"
#endif

// Debris Fields
#include "space/_debrisfield.dm"
#include "space/_templates.dm"
/datum/map_template/triumph_lateload/away_debrisfield
	name = "Debris Field - Z1 Space"
	desc = "A random debris field out in space."
	mappath = 'space/debrisfield.dmm'
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_debrisfield
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = FALSE)

/datum/map_z_level/triumph_lateload/away_debrisfield
	name = "Away Mission - Debris Field"
	z = Z_LEVEL_DEBRISFIELD


/datum/map_template/triumph_lateload/away_debrisfield/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_DEBRISFIELD), 125, /area/space/debrisfield/unexplored, /datum/map_template/debrisfield/)

// Pirate base
#include "space/_piratebase.dm"

/datum/map_template/triumph_lateload/away_piratebase
	name = "Away Mission - Pirate Base"
	desc = "A Vox Marauder Base, oh no!"
	mappath = 'space/piratebase.dmm'
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_piratebase
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = FALSE)

/datum/map_z_level/triumph_lateload/away_piratebase
	name = "Away Mission - Pirate Base"
	z = Z_LEVEL_PIRATEBASE

/datum/map_template/triumph_lateload/away_piratebase/on_map_loaded(z)
	. = ..()

// Mining Planet
#include "mining_planet/_miningplanet.dm"

/datum/map_template/triumph_lateload/away_mining_planet
	name = "Away Mission - Mining Planet"
	desc = "Mining Plante. For the miners to get actual supplies."
	mappath = 'mining_planet/mining_planet.dmm'
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
#include "lavaland/_templates.dm"
/datum/map_template/triumph_lateload/lavaland
	name = "Away Mission - Lava Land"
	desc = "The fabled."
	mappath = 'lavaland/lavaland.dmm'
	associated_map_datum = /datum/map_z_level/triumph_lateload/lavaland
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_z_level/triumph_lateload/lavaland
	name = "Away Mission - Lava Land"
	z = Z_LEVEL_LAVALAND

/datum/map_template/triumph_lateload/lavaland/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_LAVALAND), 40, /area/lavaland/unexplored, /datum/map_template/lavaland)
	new /datum/random_map/noise/ore/lavaland(null, 1, 1, Z_LEVEL_LAVALAND, 64, 64)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_LAVALAND, world.maxx - 4, world.maxy - 4) // Create the lavaland Z-level.


// Class D Rogue Planet Exploration Zone.
#include "poi_d/_class_d.dm"
#include "poi_d/_templates.dm"
/datum/map_template/triumph_lateload/away_d_world
	name = "ExoPlanet - Z1 Planet"
	desc = "A random unknown planet."
	mappath = 'poi_d/Class_D.dmm'
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_d_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/triumph_lateload/away_d_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_UNKNOWN_PLANET), 150, /area/poi_d/unexplored, /datum/map_template/Class_D)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/triumph_lateload/away_d_world
	name = "Away Mission - Rogue Planet"
	z = Z_LEVEL_UNKNOWN_PLANET

// Class H Desert Planet Exploration Zone.
#include "poi_h/_class_h.dm"
#include "poi_h/_templates.dm"
/datum/map_template/triumph_lateload/away_h_world
	name = "ExoPlanet - Z2 Planet"
	desc = "A random unknown planet."
	mappath = 'poi_h/Class_H.dmm'
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_h_world
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/triumph_lateload/away_h_world/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_DESERT_PLANET), 150, /area/poi_h/unexplored, /datum/map_template/Class_H)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/triumph_lateload/away_h_world
	name = "Away Mission - Desert Planet"
	z = Z_LEVEL_DESERT_PLANET

// Gaia Planet Zone.
#include "gaia_planet/_gaia_planet.dm"
/datum/map_template/triumph_lateload/gaia_planet
	name = "Gaia Planet - Z3 Planet"
	desc = "A lush Gaia Class Planet."
	mappath = 'gaia_planet/gaia_planet.dmm'
	associated_map_datum = /datum/map_z_level/triumph_lateload/gaia_planet
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/triumph_lateload/gaia_planet/on_map_loaded(z)
	. = ..()
//	seed_submaps(list(Z_LEVEL_DESERT_PLANET), 150, /area/poi_h/unexplored, /datum/map_template/Class_H)

	//new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNKNOWN_PLANET, world.maxx - 30, world.maxy - 30)
	//new /datum/random_map/noise/ore/poi_d(null, 1, 1, Z_LEVEL_UNKNOWN_PLANET, 64, 64)

/datum/map_z_level/triumph_lateload/gaia_planet
	name = "Away Mission - Gaia Planet"
	z = Z_LEVEL_GAIA_PLANET


// Frozen Planet Zone.
#include "frozen_planet/_frozen_planet.dm"
#include "frozen_planet/_templates.dm"
/datum/map_template/triumph_lateload/frozen_planet
	name = "Forzen Planet - Z4 Planet"
	desc = "A Cold Frozen Planet."
	mappath = 'frozen_planet/frozen_planet.dmm'
	associated_map_datum = /datum/map_z_level/triumph_lateload/frozen_planet
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)

/datum/map_template/triumph_lateload/frozen_planet/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_FROZEN_PLANET), 125, /area/frozen_planet/ruins, /datum/map_template/frozen_planet/)


/datum/map_z_level/triumph_lateload/frozen_planet
	name = "Away Mission - Frozen Planet"
	z = Z_LEVEL_FROZEN_PLANET

// Trade post
#include "space/trade_port/_tradeport.dm"

/datum/map_template/triumph_lateload/away_tradeport
	name = "Away Mission - Trade Port"
	desc = "A space gas station! Stretch your legs!"
	mappath = 'space/trade_port/tradeport.dmm'
	associated_map_datum = /datum/map_z_level/triumph_lateload/away_tradeport
	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = FALSE)

/datum/map_z_level/triumph_lateload/away_tradeport
	name = "Away Mission - Trade Port"
	z = Z_LEVEL_TRADEPORT

/datum/map_template/triumph_lateload/away_tradeport/on_map_loaded(z)
	. = ..()



//////////////////////////////////////////////////////////////////////////////////////
// Admin-use z-levels for loading whenever an admin feels like
#if AWAY_MISSION_TEST
#include "admin_use/spa.dmm"
#endif

#include "admin_use/fun.dm"
/datum/map_template/triumph_lateload/fun/spa
	name = "Space Spa"
	desc = "A pleasant spa located in a spaceship."
	mappath = 'admin_use/spa.dmm'

	associated_map_datum = /datum/map_z_level/triumph_lateload/fun/spa

/datum/map_z_level/triumph_lateload/fun/spa
	name = "Spa"
	flags = MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED

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

/obj/effect/step_trigger/zlevel_fall/Initialize()
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
	mappath = 'rogue_mines/rogue_mine1.dmm'

	associated_map_datum = /datum/map_z_level/triumph_lateload/roguemines1

/datum/map_z_level/triumph_lateload/roguemines1
	name = "Belt 1"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_1

/datum/map_template/triumph_lateload/tether_roguemines2
	name = "Asteroid Belt 2"
	desc = "Mining, but rogue. Zone 2"
	mappath = 'rogue_mines/rogue_mine2.dmm'

	associated_map_datum = /datum/map_z_level/triumph_lateload/roguemines2

/datum/map_z_level/triumph_lateload/roguemines2
	name = "Belt 2"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_2

/datum/map_template/triumph_lateload/tether_roguemines3
	name = "Asteroid Belt 3"
	desc = "Mining, but rogue. Zone 3"
	mappath = 'rogue_mines/rogue_mine3.dmm'

	associated_map_datum = /datum/map_z_level/triumph_lateload/roguemines3

/datum/map_z_level/triumph_lateload/roguemines3
	name = "Belt 3"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_3

/datum/map_template/triumph_lateload/tether_roguemines4
	name = "Asteroid Belt 4"
	desc = "Mining, but rogue. Zone 4"
	mappath = 'rogue_mines/rogue_mine4.dmm'

	associated_map_datum = /datum/map_z_level/triumph_lateload/roguemines4

/datum/map_z_level/triumph_lateload/roguemines4
	name = "Belt 4"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_4
