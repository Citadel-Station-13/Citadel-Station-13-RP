/datum/map_layer/terrain
	abstract_type = /datum/map_layer/terrain

/**
 * terrain phase - setup base turfs and areas of the area into buffer
 *
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * bounds - bounds in map bounds list format
 * * offsets - list(x, y, z)
 * * lookup - list of lists of length [MAPGEN_TERRAIN_LOOKUP_SIZE]. Please use the defines for indices into these lists.
 * * buffer - flat list[width * height]. use #define'd helpers to access.
 */
/datum/map_layer/terrain/proc/terrain_phase(datum/map_generation/generation, list/bounds, list/offsets, list/lookup, list/buffer)

/**
 * imprint areas used in generation
 *
 * these areas already have their categorical/variation/bitfield's set
 *
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * bounds - bounds in map bounds list format
 * * offsets - list(x, y, z)
 * * instances - list of area instances
 */
/datum/map_layer/terrain/proc/area_phase(datum/map_generation/generation, list/bounds, list/offsets, list/area/instances)

/**
 * final processing on placed turfs
 *
 * *YOU* are responsible for verifying that the turfs are 'yours' in terms of this layer.
 *
 * todo: lookup tuple-list should have an UID to determine if a map layer was used for an area's terrain
 * 
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * bounds - bounds in map bounds list format
 * * offsets - list(x, y, z)
 */
/datum/map_layer/terrain/proc/turf_phase(datum/map_generation/generation, list/bounds, list/offsets)

/**
 * Generate preview
 *
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * x - offset'd x
 * * y - offset'd y
 * * z - offset'd z
 * * width - width
 * * height - height
 * * lookup - list of lists of length [MAPGEN_PREVIEW_LOOKUP_SIZE]. Please use the defines for indices into these lists. Write to this one.
 * * buffer - flat list[width * height]. use #define'd helpers to access. Write to this one.
 */
/datum/map_layer/terrain/proc/preview(datum/map_generation/generation, x, y, z, width, height, list/lookup, list/buffer)
