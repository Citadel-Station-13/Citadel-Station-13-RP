//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * base explosion automata
 */
/datum/automata/explosion
	abstract_type = /datum/automata/explosion

	//* config *//

	/// DAMAGE_CLASSIFER_* define to damage
	var/list/damage_multipliers

/datum/automata/explosion/init()
	// check config
	if(!damage_multipliers)
		damage_multipliers = list()
	return ..()

/**
 * @return power left
 */
/datum/automata/explosion/proc/explode_turf(turf/tile, power)
	return tile.run_ex_act(power, damage_multipliers)

/**
 * @return power left
 */
/datum/automata/explosion/proc/explode_crossed_movable(atom/movable/AM, power)
	return AM.ex_act(power, damage_multipliers)

/datum/automata/explosion/act_cross(atom/movable/AM, data)
	explode_crossed_movable(AM, data)
