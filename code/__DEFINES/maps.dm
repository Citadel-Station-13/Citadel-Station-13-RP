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

// helpers for modifying jobs, used in various job_changes.dm files
#define MAP_JOB_CHECK if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return; }
#define MAP_JOB_CHECK_BASE if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return ..(); }
#define MAP_REMOVE_JOB(jobpath) /datum/job/##jobpath/map_check() { return (SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) && ..() }

#define SPACERUIN_MAP_EDGE_PAD 15

// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_MINING "Mining"
/*
#define ZTRAIT_REEBE "Reebe"
*/
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_AWAY "Away Mission"
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

// number - bombcap is multiplied by this before being applied to bombs
#define ZTRAIT_BOMBCAP_MULTIPLIER "Bombcap Multiplier"

// number - default gravity if there's no gravity generators or area overrides present
#define ZTRAIT_GRAVITY "Gravity"

// numeric offsets - e.g. {"Down": -1} means that chasms will fall to z - 1 rather than oblivion
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

// enum - how space transitions should affect this level
#define ZTRAIT_LINKAGE "Linkage"
	// UNAFFECTED if absent - no space transitions
	#define UNAFFECTED null
	// SELFLOOPING - space transitions always self-loop
	#define SELFLOOPING "Self"
	// CROSSLINKED - mixed in with the cross-linked space pool
	#define CROSSLINKED "Cross"

// string - id for static linkage as above. only one side across all maps can have the same unique ID, more will result in errors.
// only works if the map is static.
// IS BY DEFAULT, ONE WAY. You have to set it on both zlevels pointing to each other to be two way.
#define ZTRAIT_TRANSITION_ID_NORTH "Transition ID North"
#define ZTRAIT_TRANSITION_ID_SOUTH "Transition ID South"
#define ZTRAIT_TRANSITION_ID_EAST "Transition ID East"
#define ZTRAIT_TRANSITION_ID_WEST "Transition ID West"

// string - MUST BE UNIQUE! What the above ztrait transition IDs target. same as above, don't let this conflict.
#define ZTRAIT_LEVEL_ID "Level ID"

// number - tiles of padding on edge for transitions - defaults to DEFAULT_Z_EDGE_PADDING
#define ZTRAIT_TRANSITION_PADDING "Transition Padding"

// boolean - Disable transition mirage holders - defaults to false
#define ZTRAIT_TRANSITION_NO_MIRAGE "No Transition Mirage"

// number - the range of mirage borders for transitions
#define ZTRAIT_MIRAGE_DISTANCE "Mirage Distance"

// enum - how transitions are made
#define ZTRAIT_TRANSITION_MODE "Transition Mode"
	#define ZTRANSITION_MODE_STEP_TELEPORTER "step_teleporter"
	// Make step teleporters on the turfs. will not render without mirage borders. IT IS HIGHLY RECOMMENDED THAT YOU USE PADDING 1 FOR THIS!
	#define ZTRANSITION_MODE_TURF "turf"
	// EXPERIMENTAL: attempt to utilize turfs themselves, without step teleporters. Planned to be similar to /tg/'s.

// string - type path of the z-level's baseturf (defaults to space)
#define ZTRAIT_BASETURF "Baseturf"

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
*/
#define ZTRAITS_VR list(ZTRAIT_VIRTUAL_REALITY = TRUE, ZTRAIT_AWAY = TRUE)

#define DL_NAME "name"
#define DL_TRAITS "traits"
#define DECLARE_LEVEL(NAME, TRAITS) list(DL_NAME = NAME, DL_TRAITS = TRAITS)

// must correspond to _basemap.dm for things to work correctly
#define DEFAULT_MAP_TRAITS list(\
	DECLARE_LEVEL("CentCom", ZTRAITS_CENTCOM),\
)

// Camera lock flags
#define CAMERA_LOCK_STATION 1
#define CAMERA_LOCK_MINING 2
#define CAMERA_LOCK_CENTCOM 4
#define CAMERA_LOCK_REEBE 8

//Reserved/Transit turf type
#define RESERVED_TURF_TYPE /turf/open/space/basic			//What the turf is when not being used

//Ruin Generation

#define PLACEMENT_TRIES 100 //How many times we try to fit the ruin somewhere until giving up (really should just swap to some packing algo)

#define PLACE_DEFAULT "random"
#define PLACE_SAME_Z "same" //On same z level as original ruin
#define PLACE_SPACE_RUIN "space" //On space ruin z level(s)
#define PLACE_LAVA_RUIN "lavaland" //On lavaland ruin z levels(s)
#define PLACE_BELOW "below" //On z levl below - centered on same tile
#define PLACE_ISOLATED "isolated" //On isolated ruin z level
//Map type stuff.
#define MAP_TYPE_STATION "station"

//Random z-levels name defines.
#define AWAY_MISSION_NAME "Away Mission"
#define VIRT_REALITY_NAME "Virtual Reality"



///// VORESTATIONS TUFF BELOW.
// Z-level flags bitfield - Set these flags to determine the z level's purpose
#define MAP_LEVEL_STATION		0x001 // Z-levels the station exists on
#define MAP_LEVEL_ADMIN			0x002 // Z-levels for admin functionality (Centcom, shuttle transit, etc)
#define MAP_LEVEL_CONTACT		0x004 // Z-levels that can be contacted from the station, for eg announcements
#define MAP_LEVEL_PLAYER		0x008 // Z-levels a character can typically reach
#define MAP_LEVEL_SEALED		0x010 // Z-levels that don't allow random transit at edge
#define MAP_LEVEL_EMPTY			0x020 // Empty Z-levels that may be used for various things (currently used by bluespace jump)
#define MAP_LEVEL_CONSOLES		0x040 // Z-levels available to various consoles, such as the crew monitor (when that gets coded in). Defaults to station_levels if unset.
#define MAP_LEVEL_XENOARCH_EXEMPT 0x080	// Z-levels exempt from xenoarch digsite generation.

// Misc map defines.
#define SUBMAP_MAP_EDGE_PAD 8 // Automatically created submaps are forbidden from being this close to the main map's edge.	//VOREStation Edit

