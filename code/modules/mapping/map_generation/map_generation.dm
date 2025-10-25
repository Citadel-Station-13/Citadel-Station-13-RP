//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/map_generation
	/// layers. set to typepath / anonymous types to init.
	var/list/datum/map_generation_layer/layers

#warn impl

/datum/map_generation/proc/run(datum/map_generation_cycle/cycle)
	if(!cycle.validate())
		cycle.set_empty_result_buffer()
		CRASH("cycle failed validation. was a var not set?")

/datum/map_generation/proc/
