/**
 * default implemetation of filling the entire map (or a portion of it) with a certain set of turfs
 */
/datum/map_layer/terrain/flat
	/// area type
	var/area_type = /area/dynamic
	/// turf type
	var/turf_type = /turf/space
	/// area categorical
	var/area_categorical
	/// area variation
	var/area_variation
	/// area bitfield
	var/area_bitfield
	/// lower x
	var/min_x = -INFINITY
	/// lower y
	var/min_y = -INFINITY
	/// upper x
	var/max_x = INFINITY
	/// upper y
	var/max_y = INFINITY

/datum/map_layer/terrain/flat/terrain_phase(datum/map_generation/generation, list/bounds, list/offsets, list/lookup, list/buffer)
	. = ..()
	MAPGEN_UNPACK_VARIABLES
	var/list/built = new /list(MAPGEN_TERRAIN_LOOKUP)
	built[MAPGEN_TERRAIN_LOOKUP_AREAPATH] = area_type
	built[MAPGEN_TERRAIN_LOOKUP_TURFPATH] = turf_type
	built[MAPGEN_TERRAIN_LOOKUP_BITFIELD] = area_bitfield
	built[MAPGEN_TERRAIN_LOOKUP_CATEGORICAL] = area_categorical
	built[MAPGEN_TERRAIN_LOOKUP_VARIATION] = area_variation
	lookup[++lookup.len] = built
	var/lookup_index = lookup.len
	for(var/x in max(1, min_x - offset_x + 1) to min(width, max_x - offset_x + 1))
		for(var/y in max(1, min_y - offset_y + 1) to min(height, max_y - offset_y + 1))
			buffer[MAPGEN_BUFFER_INDEX(x, y)] = lookup_index

/datum/map_layer/terrain/flat/preview(datum/map_generation/generation, x, y, z, width, height, list/lookup, list/buffer)
	. = ..()
	var/list/built = new /list(MAPGEN_PREVIEW_LOOKUP)
	built[MAPGEN_PREVIEW_LOOKUP_COLOR] = "#888888"
	lookup[++lookup.len] = built
	var/lookup_index = lookup.len
	for(var/x in max(1, min_x - x + 1) to min(width, max_x - x + 1))
		for(var/y in max(1, min_y - y + 1) to min(height, max_y - y + 1))
			buffer[MAPGEN_BUFFER_INDEX(x, y)] = lookup_index
