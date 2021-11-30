/*
The /tg/ codebase allows mixing of hardcoded and dynamically-loaded z-levels.
Z-levels can be reordered as desired and their properties are set by "traits".
See map_config.dm for how a particular station's traits may be chosen.
The list DEFAULT_MAP_TRAITS at the bottom of this file should correspond to
the maps that are hardcoded, as set in _maps/_basemap.dm. SSmapping is
responsible for loading every non-hardcoded z-level.

As of 2018-02-04, the typical z-levels for a single-level station are:
1: CentCom
2: Station
3-4: Randomized space
5: Mining
6: City of Cogs
7-11: Randomized space
12: Empty space
13: Transit space

Multi-Z stations are supported and multi-Z mining and away missions would
require only minor tweaks.
*/

// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_MINING "Mining"
#define ZTRAIT_FACILITY_SAFETY "FacilityWeaponLock"
/*
#define ZTRAIT_REEBE "Reebe"
*/
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_AWAY "Away Mission"
/*
#define ZTRAIT_VR "Virtual Reality"
#define ZTRAIT_SPACE_RUINS "Space Ruins"
#define ZTRAIT_LAVA_RUINS "Lava Ruins"
#define ZTRAIT_ICE_RUINS "Ice Ruins"
#define ZTRAIT_ICE_RUINS_UNDERGROUND "Ice Ruins Underground"
#define ZTRAIT_ISOLATED_RUINS "Isolated Ruins" //Placing ruins on z levels with this trait will use turf reservation instead of usual placement.
#define ZTRAIT_VIRTUAL_REALITY "Virtual Reality"

//boolean - weather types that occur on the level
#define ZTRAIT_SNOWSTORM "Weather_Snowstorm"
#define ZTRAIT_ASHSTORM "Weather_Ashstorm"
#define ZTRAIT_ACIDRAIN "Weather_Acidrain"
*/

// number - bombcap is multiplied by this before being applied to bombs
#define ZTRAIT_BOMBCAP_MULTIPLIER "Bombcap Multiplier"

// number - default gravity if there's no gravity generators or area overrides present
#define ZTRAIT_GRAVITY "Gravity"

// numeric offsets - e.g. {"Down": -1} means that chasms will fall to z - 1 rather than oblivion
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

// string - level name
#define ZTRAIT_NAME "Name"

// enum - how space transitions should affect this level
#define ZTRAIT_LINKAGE "Linkage"
	// UNAFFECTED if absent - no space transitions
	#define UNAFFECTED null
	// SELFLOOPING - space transitions always self-loop
	#define SELFLOOPING "Self"
	// CROSSLINKED - mixed in with the cross-linked space pool
	#define CROSSLINKED "Cross"

// string - type path of the z-level's baseturf (defaults to space)
#define ZTRAIT_BASETURF "Baseturf"

/// Default gas string. Use for things like setting planetary gasmixtures and such. ATMOSPHERE_ID_USE_ZTRAIT to have a turf use it.
#define ZTRAIT_DEFAULT_ATMOS "Default Gas String"

// default trait definitions, used by SSmapping
#define ZTRAITS_CENTCOM list(ZTRAIT_CENTCOM = TRUE)
#define ZTRAITS_STATION list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_STATION = TRUE)
#define ZTRAITS_SPACE list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_SPACE_RUINS = TRUE)
/*
#define ZTRAITS_LAVALAND list(\
    ZTRAIT_MINING = TRUE, \
	ZTRAIT_ASHSTORM = TRUE, \
    ZTRAIT_LAVA_RUINS = TRUE, \
    ZTRAIT_BOMBCAP_MULTIPLIER = 5, \
    ZTRAIT_BASETURF = /turf/open/lava/smooth/lava_land_surface)
#define ZTRAITS_REEBE list(ZTRAIT_REEBE = TRUE, ZTRAIT_BOMBCAP_MULTIPLIER = 0.5)
#define ZTRAITS_VR list(ZTRAIT_VIRTUAL_REALITY = TRUE, ZTRAIT_AWAY = TRUE)
*/
