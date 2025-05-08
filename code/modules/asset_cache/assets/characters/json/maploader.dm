//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains:
 *
 * * map traits
 * * map attributes
 */
/datum/asset_pack/json/map_system
	name = "MapSystem"

/datum/asset_pack/json/map_system/generate()
	. = list()

	var/list/assembled_traits = list()
	for(var/datum/map_level_trait/map_level_trait_path as anything in subtypesof(/datum/map_level_trait))
		assembled_traits[initial(map_level_trait_path.id)] = list(
			"id" = initial(map_level_trait_path.id),
			"desc" = initial(map_level_trait_path.desc),
			"allowEdit" = initial(map_level_trait_path.allow_edit),
		)
	.["keyedLevelTraits"] = assembled_traits

	var/list/assembled_attributes = list()
	for(var/datum/map_level_attribute/map_level_attribute_path as anything in subtypesof(/datum/map_level_attribute))
		assembled_attributes[initial(map_level_attribute_path.id)] = list(
			"id" = initial(map_level_attribute_path.id),
			"desc" = initial(map_level_attribute_path.desc),
			"allowEdit" = initial(map_level_attribute_path.allow_edit),
		)
	.["keyedLevelAttributes"] = assembled_attributes
