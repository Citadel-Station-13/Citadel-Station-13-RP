//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Called before every fire() call, with (datum/gun_firing_cycle/cycle).
 */
#define COMSIG_GUN_FIRING_CYCLE_ITERATION_PREFIRE "gun-firing-iteration"

/**
 * Called before initiation of a firing cycle, with (datum/gun_firing_cycle/cycle).
 */
#define COMSIG_GUN_FIRING_CYCLE_START "gun-firing-start"

/**
 * Called on end of a firing cycle, with (datum/gun_firing_cycle/cycle).
 */
#define COMSIG_GUN_FIRING_CYCLE_END "gun-firing-end"
