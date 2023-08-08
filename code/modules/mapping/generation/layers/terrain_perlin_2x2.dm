/**
 * default implementation of 2x2 perlin-based terrain generation
 */
/datum/map_layer/terrain/perlin_2x2
	/// zoom - higher = bigger biomes
	var/zoom = 20
	/// low temp, high elevation
	var/biome_cold_peak
	/// high temp, high elevation
	var/biome_hot_peak
	/// low temp, low elevation
	var/biome_cold_flat
	/// high temp, low elevation
	var/biome_hot_flat

#warn impl all



