#define TURF_REMOVE_CROWBAR (1<<0)
#define TURF_REMOVE_SCREWDRIVER (1<<1)
#define TURF_REMOVE_SHOVEL (1<<2)
#define TURF_REMOVE_WRENCH (1<<3)
#define TURF_CAN_BREAK (1<<4)
#define TURF_CAN_BURN (1<<5)
#define TURF_HAS_EDGES (1<<6)
#define TURF_HAS_CORNERS (1<<7)
#define TURF_HAS_INNER_CORNERS (1<<8)
#define TURF_IS_FRAGILE (1<<9)
#define TURF_ACID_IMMUNE (1<<10)
#define TURF_IS_WET (1<<11)
#define TURF_HAS_RANDOM_BORDER (1<<12)
#define TURF_DISALLOW_BLOB (1<<13)

//Used for floor/wall smoothing
///Smooth only with itself
#define SMOOTH_NONE 0
///Smooth with all of type
#define SMOOTH_ALL 1
///Smooth with a whitelist of subtypes
#define SMOOTH_WHITELIST 2
///Smooth with all but a blacklist of subtypes
#define SMOOTH_BLACKLIST 3
/// Use a whitelist and a blacklist at the same time. atom smoothing only
#define SMOOTH_GREYLIST 4
#define isCardinal(x)			(x == NORTH || x == SOUTH || x == EAST || x == WEST)
#define isDiagonal(x)			(x == NORTHEAST || x == SOUTHEAST || x == NORTHWEST || x == SOUTHWEST)

//Wet floor type flags. Stronger ones should be higher in number.
/// Turf is dry and mobs won't slip
#define TURF_DRY (0)
/// Turf has water on the floor and mobs will slip unless walking or using galoshes
#define TURF_WET_WATER (1<<0)
/// Turf has a thick layer of ice on the floor and mobs will slip in the direction until they bump into something
#define TURF_WET_PERMAFROST (1<<1)
/// Turf has a thin layer of ice on the floor and mobs will slip
#define TURF_WET_ICE (1<<2)
/// Turf has lube on the floor and mobs will slip
#define TURF_WET_LUBE (1<<3)
/// Turf has superlube on the floor and mobs will slip even if they are crawling
#define TURF_WET_SUPERLUBE (1<<4)

/// Checks if a turf is wet
#define IS_WET_OPEN_TURF(O) O.GetComponent(/datum/component/wet_floor)

/// Maximum amount of time, (in deciseconds) a tile can be wet for.
#define MAXIMUM_WET_TIME 5 MINUTES
