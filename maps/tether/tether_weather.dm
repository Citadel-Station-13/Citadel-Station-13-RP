////////////////////////////////////////////
/// Tether Z Level Weather Definerinator ///
////////////////////////////////////////////
/*
Designates the z levels for weather to generate on. TODO, find a way of
handling this automatically without having to load these after the map defines.
The rest of the weather defines have been moved to code/modules/maps/weather

*/

///////////////////////
/// Virgo3b Weather ///
///////////////////////

var/datum/planet/virgo3b/planet_virgo3b = null

/datum/planet/virgo3b/New()
	..()
	planet_virgo3b = src
	weather_holder = new /datum/weather_holder/virgo3b(src)


/datum/planet/virgo3b
	expected_z_levels = list(
						Z_LEVEL_SURFACE_LOW,
						Z_LEVEL_SURFACE_MID,
						Z_LEVEL_SURFACE_HIGH,
						Z_LEVEL_SURFACE_MINE,
						Z_LEVEL_SOLARS,
						Z_LEVEL_PLAINS
						)


///////////////////////
/// Virgo 4 Weather ///
///////////////////////
var/datum/planet/virgo4/planet_virgo4 = null

/datum/planet/virgo4/New()
	..()
	planet_virgo4 = src
	weather_holder = new /datum/weather_holder/virgo4(src)

/datum/planet/virgo4
	expected_z_levels = list(Z_LEVEL_BEACH, Z_LEVEL_DESERT)



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

