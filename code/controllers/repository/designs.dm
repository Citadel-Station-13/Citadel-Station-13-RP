//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(designs)
	name = "Repository - Designs"
	expected_type = /datum/prototype/design
	database_key = "design"

	//* caches *//

	/// cached autolathe desgin ids
	var/tmp/list/autolathe_design_ids
	/// cached medical mini autolathe desgin ids
	var/tmp/list/medical_mini_design_ids

/datum/controller/repository/designs/Create()
	autolathe_design_ids = list()
	medical_mini_design_ids = list()
	return ..()

/datum/controller/repository/designs/load(datum/prototype/design/instance)
	. = ..()
	if(!.)
		return
	if(instance.lathe_type & LATHE_TYPE_AUTOLATHE)
		autolathe_design_ids += instance.id
	if(istype(instance, /datum/prototype/design/medical))
		medical_mini_design_ids += instance.id

/datum/controller/repository/designs/unload(datum/prototype/design/instance)
	. = ..()
	if(instance.lathe_type & LATHE_TYPE_AUTOLATHE)
		autolathe_design_ids -= instance.id
	if(istype(instance, /datum/prototype/design/medical))
		medical_mini_design_ids -= instance.id
