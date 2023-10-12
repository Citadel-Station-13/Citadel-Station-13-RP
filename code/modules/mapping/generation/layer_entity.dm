/datum/map_layer/entity
	abstract_type = /datum/map_layer/entity

/**
 * structural sweep - setup structures of the area
 *
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * bounds - bounds in map bounds list format
 * * offsets - list(x, y, z)
 */
/datum/map_layer/entity/proc/structural_sweep(datum/map_generation/generation, list/bounds, list/offsets)

/**
 * entity sweep - placing stuff like trees and mobs
 *
 * @params
 * * generation - generation instance; avoid using this as much as possible.
 * * bounds - bounds in map bounds list format
 * * offsets - list(x, y, z)
 */
/datum/map_layer/entity/proc/entity_sweep(datum/map_generation/generation, list/bounds, list/offsets)

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
 * * lookup_terrain - lookup from last phase. Read only.
 * * buffer_terrain - lookup from last phase. Read only.
 * * lookup_entity - list of lists of length [MAPGEN_PREVIEW_LOOKUP_SIZE]. Please use the defines for indices into these lists. Write to this one.
 * * buffer_entity - flat list[width * height]. use #define'd helpers to access. Write to this one.
 */
/datum/map_layer/entity/proc/preview(datum/map_generation/generation, x, y, z, width, height, list/lookup_terrain, list/buffer_terrain, list/lookup_entity, list/buffer_entity)
