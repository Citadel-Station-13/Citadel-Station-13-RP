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

/*
// helpers for modifying jobs, used in various job_changes.dm files
#define MAP_JOB_CHECK if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return; }
#define MAP_JOB_CHECK_BASE if(SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) { return ..(); }
#define MAP_REMOVE_JOB(jobpath) /datum/job/##jobpath/map_check() { return (SSmapping.config.map_name != JOB_MODIFICATION_MAP_NAME) && ..() }

#define SPACERUIN_MAP_EDGE_PAD 15
*/

/*
// Camera lock flags
#define CAMERA_LOCK_STATION 1
#define CAMERA_LOCK_MINING 2
#define CAMERA_LOCK_CENTCOM 4
#define CAMERA_LOCK_REEBE 8
*/

/*
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
*/
