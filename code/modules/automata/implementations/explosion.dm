//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * continuous explosions
 */
/datum/automata/explosion
	/// origin turfs, associated to powers
	var/list/origins
	/// multiply to power per step traveled
	var/falloff_exp
	/// subtract to power per step traveled
	var/falloff_lin

	//* config *//

	/// DAMAGE_CLASSIFER_* define to damage
	var/list/damage_multipliers
	/// maximum iterations
	var/max_iterations
	/// power at which we drop a turf
	var/considered_dead

	//* processing variables *//

	/// current iteration
	var/iteration

	/// processed turfs, assoc list to power. makes sure we don't fold in on ourselves.
	var/list/processed
	/// current edges
	var/list/edge_turfs
	/// current powers
	var/list/edge_powers
	/// current directions
	var/list/edge_dirs

/**
 * @params
 * * epicenter - a turf, or a list of turfs associated to powers
 * * power - power on epicenter, or null if epicenter is an associative list
 * * falloff_exp - multiplier to power per iteration. 0 to 1, inclusive
 * * falloff_lin - subtractor to power per iteration. 0 to infinity, inclusive
 * * max_iterations - maximum expansions. not exactly the same as a range variable but somewhat close. 0 to 1000, inclusive.
 * * considered_dead - power below this value is dropped immediately.
 */
/datum/automata/explosion/setup(turf/epicenter, power, falloff_exp, falloff_lin, max_iterations = 1000, considered_dead = INFINITY)
	// clamped
	src.max_iterations = clamp(max_iterations, 0, 1000)
	src.considered_dead = max(0, considered_dead)
	src.falloff_exp = clamp(falloff_exp, 0, 1)
	src.falloff_lin = clamp(falloff_lin, 0, INFINITY)

/datum/automata/explosion/init()
	// check config
	max_iterations = clamp(max_iterations, 0, 1000)
	if(!damage_multipliers)
		damage_multipliers = list()
	considered_dead = clamp(considered_dead, 0, INFINITY)
	// init processing vars
	iteration = 0
	processed = list()
	#warn edge
	return ..()

/datum/automata/explosion/tick()
	#warn impl

/datum/automata/explosion/act_cross(atom/movable/AM, data)
	#warn impl

#warn impl
