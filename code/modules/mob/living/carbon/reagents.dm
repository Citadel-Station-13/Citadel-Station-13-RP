//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Core reagent simulation code goes in here. *//
// todo: /datum/reagent_effect, better handling.

/**
 * Compounds CHEMICAL_EFFECT_* for this cycle via add. 
 * 
 * You should never mix this with the other ways of compounding, for the same effect.
 */
/mob/living/carbon/proc/add_reagent_cycle_effect(effect, magnitude)
	reagent_cycle_effects[effect] = magnitude + reagent_cycle_effects[effect]

/**
 * Compounds CHEMICAL_EFFECT_* for this cycle via max(). 
 * 
 * You should never mix this with the other ways of compounding, for the same effect.
 */
/mob/living/carbon/proc/max_reagent_cycle_effect(effect, magnitude)
	reagent_cycle_effects[effect] = max(reagent_cycle_effects[effects], magnitude)

/**
 * Compounds CHEMICAL_EFFECT_* for this cycle via max(). 
 * 
 * You should never mix this with the other ways of compounding, for the same effect.
 */
/mob/living/carbon/proc/multiply_reagent_cycle_effect(effect, magnitude)
	reagent_cycle_effects[effect] = (reagent_cycle_effects[effects] || 1) * magnitude

/**
 * Clear cycle effects to start a new cycle.
 */
/mob/living/carbon/proc/next_reagent_cycle()
	reagent_cycle_effects = list()
