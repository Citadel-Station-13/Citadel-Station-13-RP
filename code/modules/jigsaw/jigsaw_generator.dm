//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Datum used to generate jigsaw dungeons.
 */
/datum/jigsaw_generator
	var/datum/jigsaw_generator_config/config
	var/algorithm_type = /datum/jigsaw_algorithm/general

/datum/jigsaw_generator/New(datum/jigsaw_generator_config/config)
	src.config = config

/datum/jigsaw_generator/proc/generate(datum/jigsaw_buffer/buffer)
	var/datum/jigsaw_algorithm/algorithm = new src.algorithm_type
	return algorithm.execute(buffer, config)
