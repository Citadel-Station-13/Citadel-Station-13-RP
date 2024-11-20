//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains:
 *
 * * Typepath data for the current compile relating to spawnable and usable objects.
 *
 * Conditionally requires:
 *
 * * asset_pack/spritesheet/world_typepaths - if you need anything rendered, this needs to be there.
 */
/datum/asset_pack/json/world_typepaths
	name = "WorldTypepaths"

/datum/asset_pack/json/world_typepaths/generate()
	. = list()

	var/list/assembled_turfs = list()
	for(var/turf/turf_path as anything in typesof(/turf))
		if(initial(turf_path.abstract_type) == turf_path)
			continue
		if(!initial(turf_path.turf_spawn_flags))
			continue
		assembled_turfs[++assembled_turfs.len] = list(
			"name" = initial(turf_path.name),
			"path" = "[turf_path]",
			"flags" = "[initial(turf_path.turf_spawn_flags)]",
		)
	.["turfs"] = assembled_turfs

	var/list/assembled_objs = list()
	for(var/obj/obj_path as anything in typesof(/obj))
		if(initial(obj_path.abstract_type) == obj_path)
			continue
		if(!initial(obj_path.obj_spawn_flags))
			continue
		assembled_objs[++assembled_objs.len] = list(
			"name" = initial(obj_path.name),
			"path" = "[obj_path]",
			"flags" = "[initial(obj_path.obj_spawn_flags)]",
		)
	.["objs"] = assembled_objs

	var/list/assembled_mobs = list()
	for(var/mob/mob_path as anything in typesof(/mob))
		if(initial(mob_path.abstract_type) == mob_path)
			continue
		if(!initial(mob_path.mob_spawn_flags))
			continue
		assembled_mobs[++assembled_mobs.len] = list(
			"name" = initial(mob_path.name),
			"path" = "[mob_path]",
			"flags" = "[initial(mob_path.mob_spawn_flags)]",
		)
	.["mobs"] = assembled_mobs

	#warn impl
