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
#warn set bound size helpers on atom movable, even though we arne't using it yet
#define OVERMAP_ENTITY_MAX_BOUND_SIZE		96
/// for entity spatial hashing, the amount of space in each hash - this is the side of a square too
#define OVERMAP_SPATIAL_HASH_TILES			8
/// distance added to all spatial lookups to accomdate for large, off-center objects
#define OVERMAP_SPATIAL_ADD_LOOKUP_RADIUS	3
/// to prevent the weirdness of cross/uncross, this distance from the edge will never have anything generated in it
#define OVERMAP_GENERATION_EDGE_MARGIN		2
/// world.icon_size, constant folded. we will never have 64x64 ss13, don't lie to yourself.
#define OVERMAP_WORLD_ICON_SIZE				32
/// overmap coordinates per spatial hash grid
#define OVERMAP_SPATIAL_HASH_COORDSIZE		(OVERMAP_SPATIAL_HASH_TILES * OVERMAP_DISTANCE_PIXEL * OVERMAP_WORLD_ICON_SIZE)
/// spatial hash x y indexes to real index - hwidth and hheight are the width and height of the spatial grid
#define OVERMAP_SPATIAL_HASH_INDEX(x, y, hwidth, hheight)		(x + (y - 1) * hwidth)
/// spatial hash x y coordinates to real index - hwidth and hheight are the width and height of the spatial grid
#define OVERMAP_SPATIAL_HASH_COORD_INDEX(x, y, hwidth, hheight)	(CEILING(x / OVERMAP_SPATIAL_HASH_COORDSIZE, 1) + (CEILING(y / OVERMAP_SPATIAL_HASH_COORDSIZE, 1) - 1) * hwidth)
/// spatial hash list length for tile width/height
#define OVERMAP_SPATIAL_HASH_FOR_TILE_SIZE(x, y)		(CEILING(x / OVERMAP_SPATIAL_HASH_TILES, 1) * CEILING(y / OVERMAP_SPATIAL_HASH_TILES, 1))

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

