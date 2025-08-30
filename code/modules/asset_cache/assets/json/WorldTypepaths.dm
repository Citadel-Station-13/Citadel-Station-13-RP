//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains:
 *
 * * Typepath data for the current compile relating to spawnable and usable objects.
 */
/datum/asset_pack/json/WorldTypepaths
	name = "WorldTypepaths"

/datum/asset_pack/json/WorldTypepaths/generate()
	. = list()

	var/list/assembled_turfs = list()
	for(var/turf/turf_path as anything in typesof(/turf))
		if(initial(turf_path.abstract_type) == turf_path)
			continue
		if(!initial(turf_path.turf_spawn_flags))
			continue
		var/path = "[turf_path]"
		assembled_turfs[path] = list(
			"name" = initial(turf_path.name),
			"path" = path,
			"iconRef" = ref(initial(turf_path.icon)),
			"iconState" = initial(turf_path.icon_state),
			"spawnFlags" = initial(turf_path.turf_spawn_flags),
		)
	.["turfs"] = assembled_turfs

	var/list/assembled_areas = list()
	for(var/area/area_path as anything in typesof(/area))
		if(initial(area_path.abstract_type) == area_path)
			continue
		var/path = "[area_path]"
		assembled_areas[path] = list(
			"name" = initial(area_path.name),
			"path" = path,
			"unique" = initial(area_path.unique),
			"special" = initial(area_path.special),
		)
	.["areas"] = assembled_areas
