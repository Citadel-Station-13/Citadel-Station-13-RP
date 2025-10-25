//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/map_generation_cycle
	/// string only; random seed
	/// TODO: make deterministic on this.
	var/random_seed

	var/x_low
	var/x_high
	var/y_low
	var/y_high

	var/tmp/generated = FALSE
	var/tmp/generated_width
	var/tmp/generated_height
	/// ordered turf list of typepaths
	/// * use MAP_GENERATION_BUFFER() to access
	var/tmp/list/generated_turf_paths

/datum/map_generation_cycle/New()

/datum/map_generation_cycle/proc/initialize()
	if(isnull(random_seed))
		random_seed = "[rand(10000, 99999)]-[rand(10000, 99999)]"

/datum/map_generation_cycle/proc/validate()

/datum/map_generation_cycle/proc/set_empty_result_buffer()
	generated = TRUE

#warn impl
