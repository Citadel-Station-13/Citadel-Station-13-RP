//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Contains:
 *
 * * map traits
 * * map attributes
 */
/datum/asset_pack/json/MapSystem
	name = "MapSystem"

/datum/asset_pack/json/MapSystem/generate()
	. = list()

	var/list/assembled_traits = list()
	for(var/datum/map_level_trait/map_level_trait_path as anything in subtypesof(/datum/map_level_trait))
		assembled_traits[initial(map_level_trait_path.id)] = map_level_trait_path.ui_serialize()
	.["keyedLevelTraits"] = assembled_traits

	var/list/assembled_attributes = list()
	for(var/datum/map_level_attribute/map_level_attribute_path as anything in subtypesof(/datum/map_level_attribute))
		assembled_attributes[initial(map_level_attribute_path.id)] = map_level_attribute_path.ui_serialize()
	.["keyedLevelAttributes"] = assembled_attributes
