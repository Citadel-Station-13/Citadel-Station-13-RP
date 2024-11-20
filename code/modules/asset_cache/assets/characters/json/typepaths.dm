//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains:
 *
 * * Typepath data for the current compile.
 *
 * Conditionally requires:
 *
 * * asset_pack/spritesheet/items_by_typ
 */
/datum/asset_pack/json/typepaths
	name = "Typepaths"

/datum/asset_pack/json/typepaths/generate()
	. = list()

	var/list/assembled_turfs = list()
	for(var/turf/turf_path as anything in typesof(/turf))
		if(initial(turf_path.abstract_type) == turf_path)
	.["turfs"] = assembled_turfs

	#warn impl
