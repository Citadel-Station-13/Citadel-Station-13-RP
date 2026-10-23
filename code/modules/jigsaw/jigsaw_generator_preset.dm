//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/prototype/jigsaw_generator_preset
	abstract_type = /datum/prototype/jigsaw_generator_preset

	var/name = "Unknown Preset"
	var/desc = "Some kind of preset."

	var/datum/jigsaw_generator_config/config
	var/config_type = /datum/jigsaw_generator_config

/datum/prototype/jigsaw_generator_preset/New()
	create_config()
	..()

/datum/prototype/jigsaw_generator_preset/proc/create_config()
	if(!config && config_type)
		config = new config_type

/datum/prototype/jigsaw_generator_preset/proc/get_config()
	return config

/datum/prototype/jigsaw_generator_preset/empty
	id = "empty"
