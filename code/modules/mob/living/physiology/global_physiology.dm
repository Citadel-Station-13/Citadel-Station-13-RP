//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * physiology holder
 *
 * todo: on biologies update, we might need to lazy-cache this, and have different physiologies for each biology.
 */
/datum/global_physiology
	/// carry baseline modify
	var/carry_strength = CARRY_STRENGTH_BASELINE
	/// carry penalty modifier
	var/carry_factor = CARRY_FACTOR_BASELINE
	/// carry bias modify
	var/carry_bias = 1
	/// carry weight add - added to carry_strength for carry weight only, not encumbrance.
	var/carry_weight_add = 0
	/// carry weight factor - multiplied to carry_factor for carry weight only, not encumbrance.
	var/carry_weight_factor = 1
	/// carry weight bias - multipled to carry_bias for carry weight only, not encumbrance
	var/carry_weight_bias = 1

/datum/global_physiology/proc/reset()
	carry_strength = initial(carry_strength)
	carry_factor = initial(carry_factor)
	carry_weight_add = initial(carry_weight_add)
	carry_weight_factor = initial(carry_weight_factor)
	carry_bias = initial(carry_bias)
	carry_weight_bias = initial(carry_weight_bias)
	return TRUE

/datum/global_physiology/proc/apply(datum/physiology_modifier/modifier)
	if(!isnull(modifier.carry_strength_add))
		carry_strength += modifier.carry_strength_add
	if(!isnull(modifier.carry_strength_factor))
		carry_factor *= modifier.carry_strength_factor
	if(!isnull(modifier.carry_weight_add))
		carry_weight_add += modifier.carry_weight_add
	if(!isnull(modifier.carry_weight_factor))
		carry_weight_factor *= modifier.carry_weight_factor
	if(!isnull(modifier.carry_strength_bias))
		carry_bias *= modifier.carry_strength_bias
	if(!isnull(modifier.carry_weight_bias))
		carry_weight_bias *= modifier.carry_weight_bias

/**
 * return FALSE if we need to reset due to non-canonical operations
 */
/datum/global_physiology/proc/revert(datum/physiology_modifier/modifier)
	. = TRUE
	if(!isnull(modifier.carry_strength_add))
		carry_strength -= modifier.carry_strength_add
	if(!isnull(modifier.carry_strength_factor))
		carry_factor /= modifier.carry_strength_factor
	if(!isnull(modifier.carry_weight_add))
		carry_weight_add -= modifier.carry_weight_add
	if(!isnull(modifier.carry_weight_factor))
		carry_weight_factor /= modifier.carry_weight_factor
	if(!isnull(modifier.carry_strength_bias))
		carry_bias /= modifier.carry_strength_bias
	if(!isnull(modifier.carry_weight_bias))
		carry_weight_bias /= modifier.carry_weight_bias
