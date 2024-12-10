//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * gets the overmap entity an object is in, if any
 *
 * * if a z-index is used instead, we'll get the full sector overmap entity that it's in, or null
 * * otherwise, we will take into account shuttles.
 *
 * @params
 * * what - an /atom, or a z-index
 */
/proc/get_overmap_entity(atom/what)
	RETURN_TYPE(/obj/overmap/entity/visitable) // todo: this should just be /entity
	if(!isnum(what))
		// shuttle?
		var/area/shuttle/maybe_shuttle_area = get_area(what)
		if(istype(maybe_shuttle_area))
			return maybe_shuttle_area.shuttle.get_overmap_entity()
		// get z
		what = get_z(what)
	if((LEGACY_MAP_DATUM).use_overmap)
		return map_sectors["[what]"]
	return null
