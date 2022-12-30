// debug
#ifdef ENABLE_OVERMAP_AGGRESSIVE_ASSERT
	#define OVERMAP_AGGRESSIVE_ASSERT(statement)		ASSERT(statement)
#else
	#define OVERMAP_AGGRESSIVE_ASSERT(statement)
#endif

/**
 * distances
 * everything's real distance is pixels for obvious reasons (like us using byond pixel movement)
 */

/// units of overmap distance
#define OVERMAP_DISTANCE_UNIT "l-s"
/// overmap distance units per pixel
#define OVERMAP_DISTANCE_PIXEL 3
/// overmap distance quantization
#define OVERMAP_DISTANCE_ACCURACY 0.0001
/// duplicate of world icon size. don't lie to yourself, we aren't getting 64x64 ss13.
#define OVERMAP_WORLD_ICON_SIZE 32
/// overmap coordinate distance in a tile
#define OVERMAP_DISTANCE_TILE (OVERMAP_WORLD_ICON_SIZE * OVERMAP_DISTANCE_PIXEL)
/// overmap distance quantize helper
#define QUANTIZE_OVERMAP_DISTANCE(d) round(d, OVERMAP_DISTANCE_ACCURACY)
/// render overmap distance
#define OVERMAP_DISTANCE_RENDER(distance) "[QUANTIZE_OVERMAP_DISTANCE(distance)] l-s"
/// overmap dist to pixels
#define OVERMAP_DIST_TO_PIXEL(d) (d / OVERMAP_DISTANCE_PIXEL)
/// pixels to overmap dist
#define OVERMAP_PIXEL_TO_DIST(p) (p * OVERMAP_DISTANCE_PIXEL)
