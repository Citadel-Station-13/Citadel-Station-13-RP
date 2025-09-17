//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * get all entities within pixel distance between bounding boxes
 */
/datum/controller/subsystem/overmaps/proc/entity_pixel_dist_query(obj/overmap/entity/center_entity, pixel_dist)
	return SSspatial_grids.overmap_entities.pixel_query(center_entity, pixel_dist)

/**
 * get all entities within overmap distance between bounding boxes
 */
/datum/controller/subsystem/overmaps/proc/entity_dist_query(obj/overmap/entity/center_entity, dist)
	return entity_pixel_dist_query(center_entity, OVERMAP_DIST_TO_PIXEL(dist))
