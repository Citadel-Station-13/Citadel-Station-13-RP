//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/map_generation_layer

#warn impl

/datum/map_generation_layer/proc/terrain_step(
	list/buffer,
	x_low,
	y_low,
	x_high,
	datum/map_generation_cycle/cycle,
)
