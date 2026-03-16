//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* ------------------- alright listen up --------------------- *//
// i'm not defending this file as good API,                     *//
// but until we finish the organ rewrite & API,                 *//
// we're stuck with it.                                         *//
// this file allows for a lot of simpler things like is-synth,  *//
// synth charging checks, and more.                             *//

//-- synth cell charging API; to be replaced with proper synth rework later --//

/**
 * Checks if synth charging via cell should be procced.
 */
/mob/proc/synth_cell_charging_supported()
	return FALSE

/**
 * Gets max charge rate (as watts) for synth cell charging
 */
/mob/proc/synth_cell_charging_max_power_flow()
	return 0

/**
 * Gets joules per unit nutrition for synth cell charging
 * @return joules consumed
 */
/mob/proc/synth_cell_charging_give_power(joules)
	return 0
