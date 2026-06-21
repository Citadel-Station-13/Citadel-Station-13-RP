//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/jigsaw_spawn_resultant_config

/datum/jigsaw_spawn_config

/datum/jigsaw_spawn_config/proc/get_resultant_config() as /datum/jigsaw_spawn_resultant_config
	return new /datum/jigsaw_spawn_resultant_config

/datum/jigsaw_spawn_config/specific

/datum/jigsaw_spawn_config/specific/get_resultant_config()
	var/datum/jigsaw_spawn_resultant_config/result = new

	return result
