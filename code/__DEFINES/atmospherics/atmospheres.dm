//* Atmosphere IDs *//

//?                Abstract IDs                      ?//
//? These will be converted by SSair during loading. ?//

/// Use zlevel's outdoors air
#define ATMOSPHERE_USE_OUTDOORS "!OUTDOORS"
/// Use zlevel's indoors air
#define ATMOSPHERE_USE_INDOORS "!INDOORS"
/// Use area default
#define ATMOSPHERE_USE_AREA "!AREA"

//*                                                                  *//
//* Prefer not using stuff below on turfs.                           *//
//* You should almost always be using outdoors/indoors/area/static.  *//
//*                                                                  *//

// Tethermap
/// Virgo 2 planetary atmosphere ID
#define ATMOSPHERE_ID_VIRGO2			/datum/atmosphere/planet/virgo2
/// Sky planet atmosphere ID
#define ATMOSPHERE_ID_SKYPLANET			/datum/atmosphere/planet/sky_planet
#define ATMOSPHERE_ID_SKYPLANET_GROUND	/datum/atmosphere/planet/sky_planet/ground
/// Virgo 3b (station) planetary atmosphere ID
#define ATMOSPHERE_ID_VIRGO3B			/datum/atmosphere/planet/virgo3b
/// Lythios4c (station) atmosphere ID
#define ATMOSPHERE_ID_LYTHIOS43C		/datum/atmosphere/planet/lythios43c
/// Class H World Atmos IDs
#define ATMOSPHERE_ID_DESERT			/datum/atmosphere/planet/classh
/// Gaia PlanetAtmos IDs
#define ATMOSPHERE_ID_GAIA				/datum/atmosphere/planet/classm
/// Frozen World Atmos ID
#define ATMOSPHERE_ID_FROZEN			/datum/atmosphere/planet/classp
/// Mining Planet PlanetAtmos IDs
#define ATMOSPHERE_ID_MININGPLANET		/datum/atmosphere/planet/classg
/// Triumph Planet Atmos ID (If needed)

#define ATMOSPHERE_ID_TRIUMPH			/datum/atmosphere/planet/virgo3b

/// geothermal vent Atmos ID
#define ATMOSPHERE_ID_GEOTHERMAL        /datum/atmosphere/geothermal_vent

//LAVALAND
///what pressure you have to be under to increase the effect of equipment meant for lavaland
#define LAVALAND_EQUIPMENT_EFFECT_PRESSURE 50
#define ATMOSPHERE_ID_LAVALAND			/datum/atmosphere/planet/lavaland

/// Class D planetary atmosphere ID
#define ATMOSPHERE_ID_CLASSD			/datum/atmosphere/planet/classd
