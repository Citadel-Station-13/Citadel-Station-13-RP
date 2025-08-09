//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_clone_entity
	var/id
	var/assigned_name
	var/atom/movable/entity

/datum/buildmode_clone_entity/proc/clone_to_location(turf/location, pixel_x, pixel_y)
	if(!entity)
		return null
	var/atom/movable/cloned = entity.clone(location)
	cloned.set_base_pixel_x(cloned.base_pixel_x + pixel_x)
	cloned.set_base_pixel_y(cloned.base_pixel_y + pixel_y)
	return cloned
