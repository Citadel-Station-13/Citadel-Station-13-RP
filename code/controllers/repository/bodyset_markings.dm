//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(bodyset_markings)
	name = "Repository - Bodyset Markings"
	expected_type = /datum/prototype/bodyset_marking

	var/list/legacy_name_lookup = list()

/datum/controller/repository/bodyset_markings/load(datum/prototype/bodyset_marking/instance)
	. = ..()
	legacy_name_lookup[instance.name] = instance

/datum/controller/repository/bodyset_markings/unload(datum/prototype/bodyset_marking/instance)
	. = ..()
	legacy_name_lookup -= instance
