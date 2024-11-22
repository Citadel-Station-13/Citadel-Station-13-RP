//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(flooring)
	name = "Repository - Flooring"
	expected_type = /datum/prototype/flooring

	/// item type to buildable floor type
	var/list/build_item_lookup
	/// material id to buildable floor type
	var/list/build_material_lookup

/datum/controller/repository/flooring/Create()
	build_item_lookup = list()
	build_material_lookup = list()
	return ..()

/datum/controller/repository/flooring/load(datum/prototype/instance)
	. = ..()
	if(!.)
		return
	#warn impl - build lookup

/datum/controller/repository/flooring/unload(datum/prototype/instance)
	. = ..()
	if(!.)
		return
	#warn impl - build lookup
