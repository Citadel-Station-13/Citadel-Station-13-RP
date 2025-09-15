//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(materials)
	name = "Repository - Materials"
	expected_type = /datum/prototype/material

	var/list/legacy_material_lookup

/datum/controller/repository/materials/Create()
	legacy_material_lookup = list()
	return ..()

/datum/controller/repository/materials/load(datum/prototype/material/instance)
	if(!instance.Initialize())
		return FALSE
	. = ..()
	if(!.)
		return
	legacy_material_lookup[lowertext(instance.name)] = instance

/datum/controller/repository/materials/unload(datum/prototype/material/instance)
	. = ..()
	legacy_material_lookup -= lowertext(instance.name)
