//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains:
 *
 * * Sprite data for the current compile relating to spawnable and usable objects.
 *
 */
/datum/asset_pack/spritesheet/world_typepaths
	name = "WorldTypepaths"

/datum/asset_pack/spritesheet/world_typepaths/generate()
	. = list()

	for(var/turf/turf_path as anything in typesof(/turf))
		if(initial(turf_path.abstract_type) == turf_path)
			continue
		if(!initial(turf_path.atom_spawn_flags))
			continue
		insert("[turf_path]", initial(turf_path.icon), initial(turf_path.icon_state), null, null, null, TRUE)

	for(var/obj/obj_path as anything in typesof(/obj))
		if(initial(obj_path.abstract_type) == obj_path)
			continue
		if(!initial(obj_path.atom_spawn_flags))
			continue
		insert("[obj_path]", initial(obj_path.icon), initial(obj_path.icon_state), null, null, null, TRUE)

	for(var/mob/mob_path as anything in typesof(/mob))
		if(initial(mob_path.abstract_type) == mob_path)
			continue
		if(!initial(mob_path.atom_spawn_flags))
			continue
		insert("[mob_path]", initial(mob_path.icon), initial(mob_path.icon_state), null, null, null, TRUE)
