#define MAPGEN_TERRAIN_LOOKUP_CATEGORICAL 1
#define MAPGEN_TERRAIN_LOOKUP_VARIATION 2
#define MAPGEN_TERRAIN_LOOKUP_BITFIELD 3
#define MAPGEN_TERRAIN_LOOKUP_TURFPATH 4
#define MAPGEN_TERRAIN_LOOKUP_AREAPATH 5
#define MAPGEN_TERRAIN_LOOKUP 5

#define MAPGEN_PREVIEW_LOOKUP_COLOR 1
#define MAPGEN_PREVIEW_LOOKUP 1


/// unpacks width, height, depth from variables
#define MAPGEN_UNPACK_VARIABLES \
	var/width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1; \
	var/height = bounds[MAP_MAXY] - bounds[MAP_MINY] + 1; \
	var/real_x = bounds[MAP_MINX]; \
	var/real_y = bounds[MAP_MINY]; \
	var/real_z = bounds[MAP_MINZ]; \
	var/virtual_x = offset[1]; \
	var/virtual_y = offset[2]; \
	var/virtual_z = offset[3];

#define MAPGEN_SET_BUFFER(x, y)

