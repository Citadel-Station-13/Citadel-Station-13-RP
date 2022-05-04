/**
 * distances
 * everything's real distance is pixels for obvious reasons (like us using byond pixel movement)
 */

/// units of overmap distance
#define OVERMAP_DISTANCE_UNIT		"l-s"
/// overmap distance units per pixel
#define OVERMAP_DISTANCE_PIXEL		3
/// overmap distance quantization
#define OVERMAP_DISTANCE_ACCURACY	0.001
/// overmap distance quantize helper
#define QUANTIZE_OVERMAP_DISTANCE(d)		round(d, OVERMRAP_DISTANCE_ACCURACY)
/// render overmap distance
#define OVERMAP_DISTANCE_RENDER(distance)				"[QUANTIZE_OVERMAP_DISTANCE(distance)] l-s"

/**
 * speed - obviously derived from distance, in distance/second
 */
/// overmap absolute max speed in distance/second - this is hard limit on entity sim, NOT balancing!
#define OVERMAP_MAX_SPEED						SSovermaps.max_entity_speed
/// overmap speed accuracy
#define OVERMAP_SPEED_ACCURACY					0.001
/// overmap speed quantization
#define QUANTIZE_OVERMAP_SPEED(s)				round(s, OVERMRAP_SPEED_ACCURACY)

/**
 * overmap
 */
/// how far we visually glitz the overmap's sides
#define OVERMAP_SIDE_VISUAL_GLITZ			7
/// for entity spatial hashing, the max bound size of any entity assuming this is the side of a square
#define OVERMAP_ENTITY_MAX_BOUND_SIZE		96
/// for entity spatial hashing, the amount of space in each hash - this is the side of a square too
#define OVERMAP_SPATIAL_HASH_SIZE			8
/// distance added to all spatial lookups to accomdate for large, off-center objects
#define OVERMAP_SPATIAL_ADD_LOOKUP_RADIUS	3
/// to prevent the weirdness of cross/uncross, this distance from the edge will never have anything generated in it
#define OVERMAP_GENERATION_EDGE_MARGIN		2
/// duplicate of world icon size. don't lie to yourself, we aren't getting 64x64 ss13.
#define OVERMAP_WORLD_ICON_SIZE				32
/// during entity queries, this is the minimum range where we use spatial grid scan, in byond pixels. below this, we use bounds() fastpath
#define OVERMAP_ENTITY_QUERY_BUILTIN_RANGE_PIXELS		(OVERMAP_WORLD_ICON_SIZE * 10)	// 21x21, we assume byond isn't awful below this. above this, 8x8 spatial grids can easily be better (MAYBE)
/// during entity queries, this is the minimum range where we use spatial grid scan, in overmap coords. below this, we use bounds() fastpath
#define OVERMAP_ENTITY_QUERY_BUILTIN_RANGE				(OVERMAP_ENTITY_QUERY_BUILTIN_RANGE_PIXELS * OVERMAP_DISTANCE_PIXEL)

///////// LEGACY BELOW

#define SHIP_SIZE_TINY	1
#define SHIP_SIZE_SMALL	2
#define SHIP_SIZE_LARGE	3

//multipliers for max_speed to find 'slow' and 'fast' speeds for the ship
#define SHIP_SPEED_SLOW  1/(40 SECONDS)
#define SHIP_SPEED_FAST  3/(20 SECONDS)// 15 speed

#define OVERMAP_WEAKNESS_NONE		0
#define OVERMAP_WEAKNESS_FIRE		1
#define OVERMAP_WEAKNESS_EMP		2
#define OVERMAP_WEAKNESS_MINING		4
#define OVERMAP_WEAKNESS_EXPLOSIVE	8

#define DEFAULT_OVERMAP_RANGE 0

