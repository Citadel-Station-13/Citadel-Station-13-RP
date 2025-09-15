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

/datum/controller/repository/flooring/load(datum/prototype/flooring/instance)
	. = ..()
	if(!.)
		return
	if(ispath(instance.build_type, /obj/item/stack))
		if(build_item_lookup?[instance.build_type])
			stack_trace("attempted to load [instance.id], but build type [instance.build_type] collides with [build_item_lookup?[instance.build_type]:id]. suppressing [instance.id]'s build_type.")
		LAZYSET(build_item_lookup, instance.build_type, instance)
	else if(ispath(instance.build_type, /datum/prototype/material))
		var/datum/prototype/material/casted_material = instance.build_type
		if(build_material_lookup?[casted_material.id])
			stack_trace("attempted to load [instance.id], but material [casted_material.id] collides with [build_material_lookup?[casted_material.id]:id]. suppressing [instance.id]'s build_type.")
		LAZYSET(build_material_lookup, initial(casted_material.id), instance)

/datum/controller/repository/flooring/unload(datum/prototype/flooring/instance)
	. = ..()
	if(!.)
		return
	if(ispath(instance.build_type, /obj/item/stack))
		LAZYREMOVE(build_item_lookup, instance.build_type)
	else if(ispath(instance.build_type, /datum/prototype/material))
		var/datum/prototype/material/casted_material = instance.build_type
		LAZYREMOVE(build_material_lookup, initial(casted_material.id))
