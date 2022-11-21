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

/*
///Returns all turfs in a zlevel
#define Z_TURFS(ZLEVEL) block(locate(1,1,ZLEVEL), locate(world.maxx, world.maxy, ZLEVEL))

///Returns all currently loaded turfs
#define ALL_TURFS(...) block(locate(1, 1, 1), locate(world.maxx, world.maxy, world.maxz))
*/

#define TURF_FROM_COORDS_LIST(List) (locate(List[1], List[2], List[3]))

//! These will be useful for me at a later date @Zandairo :)
/*
/// The pipes, disposals, and wires are hidden
#define UNDERFLOOR_HIDDEN 0
/// The pipes, disposals, and wires are visible but cannot be interacted with
#define UNDERFLOOR_VISIBLE 1
/// The pipes, disposals, and wires are visible and can be interacted with
#define UNDERFLOOR_INTERACTABLE 2

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
*/

/**
 * Get the turf that `A` resides in, regardless of any containers.
 *
 * Use in favor of `A.loc` or `src.loc` so that things work correctly when
 * stored inside an inventory, locker, or other container.
 */
#define get_turf(A) (get_step(A, 0))

/**
 * Get the ultimate area of `A`, similarly to [get_turf].
 *
 * Use instead of `A.loc.loc`.
 */
#define get_area(A) (isarea(A) ? A : get_step(A, 0)?.loc)
