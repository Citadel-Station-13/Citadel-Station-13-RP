//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/directional_shield_pattern
	/// expensive. do we need to directionally orient on changing dirs?
	var/directional = FALSE

/**
 * * returned perspective should be NORTH.
 * @return list(list(x_o, y_o, dir), ...)
 */
/datum/directional_shield_pattern/proc/return_tiles() as /list
	return list()

/datum/directional_shield_pattern/linear
	directional = TRUE
	/// distance from entity; 0 is ontop.
	var/distance = 2
	/// length = halflength * 2 + 1
	var/halflength = 2

/datum/directional_shield_pattern/linear/return_tiles()
	if(halflength < 0)
		return list()
	var/list/tiles = list()
	tiles[++tiles.len] = list(
		0,
		distance,
		NORTH,
	)
	for(var/x in 1 to halflength - 1)
		tiles[++tiles.len] = list(
			x,
			distance,
			NORTH,
		)
		tiles[++tiles.len] = list(
			-x,
			distance,
			NORTH,
		)
	if(halflength > 0)
		tiles[++tiles.len] = list(
			halflength,
			distance,
			NORTHEAST,
		)
		tiles[++tiles.len] = list(
			-halflength,
			distance,
			NORTHWEST,
		)

/datum/directional_shield_pattern/square
	/// distance from entity; 2 is 5x5 with 3x3 inner, 1 is 3x3 with 1x1 inner.
	var/radius = 2

/datum/directional_shield_pattern/square/return_tiles()
	if(radius <= 0)
		return list()
	var/list/tiles = list()
	tiles[++tiles.len] = list(
		radius,
		radius,
		NORTHEAST,
	)
	tiles[++tiles.len] = list(
		radius,
		-radius,
		SOUTHEAST,
	)
	tiles[++tiles.len] = list(
		-radius,
		radius,
		NORTHWEST,
	)
	tiles[++tiles.len] = list(
		-radius,
		-radius,
		SOUTHWEST,
	)
	for(var/x in -radius + 1 to radius - 1)
		tiles[++tiles.len] = list(
			x,
			radius,
			NORTH,
		)
		tiles[++tiles.len] = list(
			x,
			-radius,
			SOUTH,
		)
	for(var/y in -radius + 1 to radius - 1)
		tiles[++tiles.len] = list(
			radius,
			y,
			EAST,
		)
		tiles[++tiles.len] = list(
			-radius,
			y,
			WEST,
		)

/datum/directional_shield_pattern/square/r_3x3
	radius = 1

/datum/directional_shield_pattern/square/r_5x5
	radius = 2

/datum/directional_shield_pattern/square/r_7x7
	radius = 3

/datum/directional_shield_pattern/square/r_9x9
	radius = 4

/datum/directional_shield_pattern/square/r_11x11
	radius = 5
