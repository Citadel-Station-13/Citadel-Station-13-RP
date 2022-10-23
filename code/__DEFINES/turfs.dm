#define TURF_REMOVE_CROWBAR     1
#define TURF_REMOVE_SCREWDRIVER 2
#define TURF_REMOVE_SHOVEL      4
#define TURF_REMOVE_WRENCH      8
#define TURF_CAN_BREAK          16
#define TURF_CAN_BURN           32
#define TURF_HAS_EDGES          64
#define TURF_HAS_CORNERS        128
#define TURF_IS_FRAGILE         256
#define TURF_ACID_IMMUNE        512

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

// #define IS_CARDINAL(x) ((x & (x - 1)) == 0) // Cardinal using math.
#define IS_CARDINAL(DIR) (DIR == NORTH || DIR == SOUTH || DIR == EAST || DIR == WEST)
#define IS_DIAGONAL(DIR) (DIR == NORTHEAST || DIR == SOUTHEAST || DIR == NORTHWEST || DIR == SOUTHWEST)


// Supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a

/**
 *! Return a list of turfs in a square.
 */
#define RANGE_TURFS(RADIUS, CENTER) \
	RECT_TURFS(RADIUS, RADIUS, CENTER)

#define RECT_TURFS(H_RADIUS, V_RADIUS, CENTER) \
	block( \
		locate(max(CENTER.x-(H_RADIUS),1),          max(CENTER.y-(V_RADIUS),1),          CENTER.z), \
		locate(min(CENTER.x+(H_RADIUS),world.maxx), min(CENTER.y+(V_RADIUS),world.maxy), CENTER.z), \
	)

/**
 *! Return a list of turfs in a square or null.
 */
#define RANGE_TURFS_OR_EMPTY(RADIUS, CENTER) \
	RECT_TURFS_OR_EMPTY(RADIUS, RADIUS, CENTER)

#define RECT_TURFS_OR_EMPTY(H_RADIUS, V_RADIUS, CENTER) \
	(CENTER? block( \
		locate(max(CENTER.x-(H_RADIUS),1),          max(CENTER.y-(V_RADIUS),1),          CENTER.z), \
		locate(min(CENTER.x+(H_RADIUS),world.maxx), min(CENTER.y+(V_RADIUS),world.maxy), CENTER.z), \
	) : list())
