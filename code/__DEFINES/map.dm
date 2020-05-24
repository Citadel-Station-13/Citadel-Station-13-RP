// Z-level flags bitfield - Set these flags to determine the z level's purpose
#define MAP_LEVEL_STATION		(1<<0) // Z-levels the station exists on
#define MAP_LEVEL_ADMIN			(1<<1) // Z-levels for admin functionality (Centcom, shuttle transit, etc)
#define MAP_LEVEL_CONTACT		(1<<2) // Z-levels that can be contacted from the station, for eg announcements
#define MAP_LEVEL_PLAYER		(1<<3) // Z-levels a character can typically reach
#define MAP_LEVEL_SEALED		(1<<4) // Z-levels that don't allow random transit at edge
#define MAP_LEVEL_EMPTY			(1<<5) // Empty Z-levels that may be used for various things (currently used by bluespace jump)
#define MAP_LEVEL_CONSOLES		(1<<6) // Z-levels available to various consoles, such as the crew monitor (when that gets coded in). Defaults to station_levels if unset.
#define MAP_LEVEL_XENOARCH_EXEMPT (1<<7)	// Z-levels exempt from xenoarch digsite generation.

// Misc map defines.
#define SUBMAP_MAP_EDGE_PAD 8 // Automatically created submaps are forbidden from being this close to the main map's edge.	//VOREStation Edit