/* smoothing_flags */
/// Smoothing system in where adjacencies are calculated and used to build an image by mounting each corner at runtime.
#define SMOOTH_CORNERS			(1<<0)
/// Smoothing system in where adjacencies are calculated and used to select a pre-baked icon_state, encoded by bitmasking.
#define SMOOTH_BITMASK			(1<<1)
/// Atom has diagonal corners, with underlays under them.
#define SMOOTH_DIAGONAL_CORNERS	(1<<2)
/// Atom will smooth with the borders of the map.
#define SMOOTH_BORDER			(1<<3)
/// Atom is currently queued to smooth.
#define SMOOTH_QUEUED			(1<<4)
/// Smooths with objects, and will thus need to scan turfs for contents.
#define SMOOTH_OBJ				(1<<5)
/// custom smoothing - citrp snowflake for floors. don't you dare use this with normal things unless you absolutely know what you're doing.
#define SMOOTH_CUSTOM			(1<<6)

/// macro for checking if something is smooth
#define IS_SMOOTH(A)			(A.smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK|SMOOTH_CUSTOM)

DEFINE_BITFIELD(smoothing_flags, list(
	"SMOOTH_CORNERS" = SMOOTH_CORNERS,
	"SMOOTH_BITMASK" = SMOOTH_BITMASK,
	"SMOOTH_DIAGONAL_CORNERS" = SMOOTH_DIAGONAL_CORNERS,
	"SMOOTH_BORDER" = SMOOTH_BORDER,
	"SMOOTH_QUEUED" = SMOOTH_QUEUED,
	"SMOOTH_OBJ" = SMOOTH_OBJ,
))

/*smoothing macros*/

#define QUEUE_SMOOTH(thing_to_queue) if(IS_SMOOTH(thing_to_queue)) {SSicon_smooth.add_to_queue(thing_to_queue)}

#define QUEUE_SMOOTH_NEIGHBORS(thing_to_queue) for(var/neighbor in orange(1, thing_to_queue)) {var/atom/atom_neighbor = neighbor; QUEUE_SMOOTH(atom_neighbor)}


/**SMOOTHING GROUPS
 * Groups of things to smooth with.
 * * Contained in the `list/smoothing_groups` variable.
 * * Matched with the `list/canSmoothWith` variable to check whether smoothing is possible or not.
 */

#define S_TURF(num) ((24 * 0) + num) //Not any different from the number itself, but kept this way in case someone wants to expand it by adding stuff before it.
/* /turf only */

// empty for now
#define MAX_S_TURF S_TURF(0) //Always match this value with the one above it.


#define S_OBJ(num) (MAX_S_TURF + 1 + num)
/* /obj included */

#define SMOOTH_GROUP_SANDBAGS S_OBJ(0) ///obj/structure/sandbag

#define MAX_S_OBJ SMOOTH_GROUP_SANDBAGS //Always match this value with the one above it.
