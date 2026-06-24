//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

REPOSITORY_DEF(jigsaw_templates)
	name = "Repository - Jigsaw Templates"
	expected_type = /datum/prototype/jigsaw_template
	database_key = "jigsaw_template"

/datum/controller/repository/jigsaw_templates/proc/unload_caches()
	for(var/id in id_lookup)
		var/datum/prototype/jigsaw_template/instance = id_lookup[id]
		if(!istype(instance))
			continue
		instance.unload_cache()
