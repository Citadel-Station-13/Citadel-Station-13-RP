//////////////////////////////////////////
/// Rift Z Level Weather Definerinator ///
//////////////////////////////////////////
/*
Designates the z levels for weather to generate on. TODO, find a way of
handling this automatically without having to load these after the map defines.
The rest of the weather defines have been moved to code/modules/maps/weather

*/

///////////////////////
/// Lythios Weather ///
///////////////////////
var/datum/planet/lythios43c/planet_lythios43c = null

/datum/planet/lythios43c
	expected_z_levels = list(
						Z_LEVEL_UNDERGROUND_FLOOR,
						Z_LEVEL_UNDERGROUND_DEEP,
						Z_LEVEL_UNDERGROUND,
						Z_LEVEL_SURFACE_LOW,
						Z_LEVEL_SURFACE_MID,
						Z_LEVEL_SURFACE_HIGH,
						Z_LEVEL_WEST_BASE,
						Z_LEVEL_WEST_DEEP,
						Z_LEVEL_WEST_CAVERN,
						Z_LEVEL_WEST_PLAIN
						)

///////////////////////
/// Class D Weather ///
///////////////////////
var/datum/planet/classd/planet_classd = null

/datum/planet/classd/New()
	..()
	planet_classd = src
	weather_holder = new /datum/weather_holder/classd(src)

/datum/planet/classd
	expected_z_levels = list(Z_LEVEL_CLASS_D)


///////////////////////
/// Class G Weather ///
///////////////////////
var/datum/planet/classg/planet_classg = null

/datum/planet/classg/New()
	..()
	planet_classg = src
	weather_holder = new /datum/weather_holder/classg(src)

/datum/planet/classg
	expected_z_levels = list(Z_LEVEL_MININGPLANET)

///////////////////////
/// Class H Weather ///
///////////////////////
var/datum/planet/classh/planet_classh = null

/datum/planet/classh/New()
	..()
	planet_classh = src
	weather_holder = new /datum/weather_holder/classh(src)


/datum/planet/classh
	expected_z_levels = list(Z_LEVEL_DESERT_PLANET)

///////////////////////
/// Class M Weather ///
///////////////////////
var/datum/planet/classm/planet_classm = null

/datum/planet/classm/New()
	..()
	planet_classm = src
	weather_holder = new /datum/weather_holder/classm(src)

/datum/planet/classm
	expected_z_levels = list(Z_LEVEL_GAIA_PLANET)

///////////////////////
/// Class P Weather ///
///////////////////////
var/datum/planet/classp/planet_classp = null

/datum/planet/classp/New()
	..()
	planet_classp = src
	weather_holder = new /datum/weather_holder/classp(src)

/datum/planet/classp
	expected_z_levels = list(Z_LEVEL_FROZEN_PLANET)

/////////////////////////
/// Lava Land Weather ///
/////////////////////////
var/datum/planet/lavaland/planet_lavaland = null

/datum/planet/lavaland/New()
	..()
	planet_lavaland = src
	weather_holder = new /datum/weather_holder/lavaland(src)

/datum/planet/lavaland
	expected_z_levels = list(
		Z_LEVEL_LAVALAND,
		Z_LEVEL_LAVALAND_EAST)

////////////////////////////
/// Miaphus'irra Weather ///
////////////////////////////
var/datum/planet/miaphus/planet_miaphus = null

/datum/planet/miaphus/New()
	..()
	planet_miaphus = src
	weather_holder = new /datum/weather_holder/miaphus(src)

/datum/planet/miaphus
	expected_z_levels = list(Z_LEVEL_BEACH, Z_LEVEL_DESERT)



