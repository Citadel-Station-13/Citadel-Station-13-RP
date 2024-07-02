//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//! All of these will be tightly coupled with TGUI. Tread lightly and do not fuck around. !//

GLOBAL_LIST_INIT(byond_generator_info, list(
	"num" = list(
		"defaults" = list(
			"A" = 0,
			"B" = 0,
		),
		"datatype" = "number",
	),
	"vector" = list(
		"defaults" = list(
			"A" = list(0, 0, 0),
			"B" = list(0, 0, 0),
		),
		"datatype" = "vec3",
	),
	"box" = list(
		"defaults" = list(
			"A" = list(0, 0, 0),
			"B" = list(0, 0, 0),
		),
		"datatype" = "vec3",
	),
	"color" = list(
		"defaults" = list(
			"A" = "#ffffff",
			"B" = "#ffffff",
		),
		"datatype" = "color",
	),
	"circle" = list(
		"defaults" = list(
			"A" = 0,
			"B" = 0,
		),
		"datatype" = "number",
	),
	"sphere" = list(
		"defaults" = list(
			"A" = 0,
			"B" = 0,
		),
		"datatype" = "number",
	),
	"square" = list(
		"defaults" = list(
			"A" = 0,
			"B" = 0,
		),
		"datatype" = "number",
	),
	"cube" = list(
		"defaults" = list(
			"A" = 0,
			"B" = 0,
		),
		"datatype" = "number",
	),
))

GLOBAL_LIST_INIT(byond_generator_rand_by_name, list(
	"Uniform" = UNIFORM_RAND,
	"Gaussian" = NORMAL_RAND,
	"Linear" = LINEAR_RAND,
	"Square" = SQUARE_RAND,
))

//* Data-List generators, able to be arglist'd *//

/**
 * @params
 * * low - number
 * * high - number
 * * rand - X_RAND define for what kind of randomness to use
 */
/proc/num_generator_args(low, high, rand = UNIFORM_RAND)
	return list(
		"type" = "num",
		"A" = low,
		"B" = high,
		"rand" = rand,
	)

/**
 * generates a random vector along a line
 *
 * @params
 * * vec3_A - a vector of list(x, y, z)
 * * vec3_B - a vector of list(x, y, z)
 * * rand - X_RAND define for what kind of randomness to use
 */
/proc/vec3_line_generator_args(list/vec3_A, list/vec3_B, rand = UNIFORM_RAND)
	return list(
		"type" = "vector",
		"A" = vec3_A,
		"B" = vec3_B,
		"rand" = rand,
	)

/**
 * generates a random vector inside a box with corners of A and B
 *
 * @params
 * * vec3_A - a vector of list(x, y, z)
 * * vec3_B - a vector of list(x, y, z)
 * * rand - X_RAND define for what kind of randomness to use
 */
/proc/vec3_box_generator_args(list/vec3_A, list/vec3_B, rand = UNIFORM_RAND)
	return list(
		"type" = "box",
		"A" = vec3_A,
		"B" = vec3_B,
		"rand" = rand,
	)

/**
 * generates a random vector inside a circle between radius A and B, centered at 0, 0
 *
 * @params
 * * low_radius - number
 * * high_radius - number
 * * rand - X_RAND define for what kind of randomness to use
 */
/proc/vec3_circle_generator_args(low_radius, high_radius, rand = UNIFORM_RAND)
	return list(
		"type" = "circle",
		"A" = low_radius,
		"B" = high_radius,
		"rand" = rand,
	)

/**
 * generates a random vector inside a sphere between radius A and B, centered at 0, 0, 0
 *
 * @params
 * * low_radius - number
 * * high_radius - number
 * * rand - X_RAND define for what kind of randomness to use
 */
/proc/vec3_sphere_generator_args(low_radius, high_radius, rand = UNIFORM_RAND)
	return list(
		"type" = "sphere",
		"A" = low_radius,
		"B" = high_radius,
		"rand" = rand,
	)

/**
 * generates a random vector inside a square between radius A and B, centered at 0, 0
 *
 * @params
 * * low_radius - number
 * * high_radius - number
 * * rand - X_RAND define for what kind of randomness to use
 */
/proc/vec3_square_generator_args(low_radius, high_radius, rand = UNIFORM_RAND)
	return list(
		"type" = "square",
		"A" = low_radius,
		"B" = high_radius,
		"rand" = rand,
	)

/**
 * generates a random vector inside a cube between radius A and B, centered at 0, 0, 0
 *
 * @params
 * * low_radius - number
 * * high_radius - number
 * * rand - X_RAND define for what kind of randomness to use
 */
/proc/vec3_cube_generator_args(low_radius, high_radius, rand = UNIFORM_RAND)
	return list(
		"type" = "cube",
		"A" = low_radius,
		"B" = high_radius,
		"rand" = rand,
	)

/**
 * generates a random color interpolated between two different colors
 *
 * A and B can either be color strings or matrices
 *
 * @params
 * * A - a color
 * * B - a color
 * * rand - X_RAND define for what kind of randomness to use
 */
/proc/color_generator_args(A, B, rand = UNIFORM_RAND)
	return list(
		"type" = "color",
		"A" = A,
		"B" = B,
		"rand" = rand,
	)
