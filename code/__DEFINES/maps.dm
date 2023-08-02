
// ! DO NOT USE ; USE NEW TRAITS SYSTEM. !//

// Z-level flags bitfield - Set these flags to determine the z level's purpose
/// Z-levels the station exists on
#define LEGACY_LEVEL_STATION		0x001
/// Z-levels for admin functionality (Centcom, shuttle transit, etc)
#define LEGACY_LEVEL_ADMIN			0x002
/// Z-levels that can be contacted from the station, for eg announcements
#define LEGACY_LEVEL_CONTACT		0x004
/// Z-levels a character can typically reach
#define LEGACY_LEVEL_PLAYER		0x008
/// Z-levels that don't allow random transit at edge
#define LEGACY_LEVEL_SEALED		0x010
/// Z-levels available to various consoles, such as the crew monitor (when that gets coded in). Defaults to station_levels if unset.
#define LEGACY_LEVEL_CONSOLES		0x040
// Misc map defines.

/// Automatically created submaps are forbidden from being this close to the main map's edge.
#define SUBMAP_MAP_EDGE_PAD 8

/// Distance from edge to move to another z-level.
#define TRANSITIONEDGE				1
