//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(designs)
	name = "Repository - Designs"
	expected_type = /datum/prototype/design
	database_key = "design"

	//* caches *//

	/// cached autolathe desgin ids
	var/tmp/list/datum/prototype/design/c_autolathe_designs
	/// cached medical mini autolathe desgin ids
	var/tmp/list/datum/prototype/design/c_medlathe_designs

/datum/controller/repository/designs/Create()
	c_autolathe_designs = list()
	c_medlathe_designs = list()
	return ..()

/datum/controller/repository/designs/load(datum/prototype/design/instance)
	. = ..()
	if(!.)
		return
	if(instance.lathe_type & LATHE_TYPE_AUTOLATHE)
		c_autolathe_designs += instance
	if(istype(instance, /datum/prototype/design/medical))
		c_medlathe_designs += instance

/datum/controller/repository/designs/unload(datum/prototype/design/instance)
	. = ..()
	if(instance.lathe_type & LATHE_TYPE_AUTOLATHE)
		c_autolathe_designs -= instance
	if(istype(instance, /datum/prototype/design/medical))
		c_medlathe_designs -= instance
