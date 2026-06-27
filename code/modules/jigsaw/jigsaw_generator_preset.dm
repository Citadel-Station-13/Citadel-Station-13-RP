//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/datum/prototype/jigsaw_generator_preset
	abstract_type = /datum/prototype/jigsaw_generator_preset

	var/name = "Unknown Preset"
	var/desc = "Some kind of preset."

	var/datum/jigsaw_generator_config/config = new

#warn impl

/datum/prototype/jigsaw_generator_preset/proc/get_config()
	return config

/datum/prototype/jigsaw_generator_preset/empty
	id = "empty"
