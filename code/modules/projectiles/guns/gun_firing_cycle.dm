//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/gun_firing_cycle
	//* cycle *//
	/// our firing cycle id - integer
	var/cycle_notch
	/// start world.time
	var/cycle_start_time
	/// iterations so far fired
	///
	/// * this is set before the fire() call, which means fire() and post_fire()
	///   can access this for current iteration.
	var/cycle_iterations_fired = 0
	/// cooldown to impart after cycle
	var/cycle_cooldown = 0.2 SECONDS

	//* targeting *//
	/// original target
	var/atom/original_target
	/// original angle
	var/original_angle
	/// original target pixel x of tile
	//  todo: re-evaluate if this is needed. this is usually for detecting exact impact spots, but is
	//        kinda janky for what it is, though there might not be a better option.
	var/original_tile_pixel_x
	/// original target pixel y of tile
	//  todo: re-evaluate if this is needed. this is usually for detecting exact impact spots, but is
	//        kinda janky for what it is, though there might not be a better option.
	var/original_tile_pixel_y
	/// original target zone
	var/original_target_zone

	//* firemode *//
	/// firemode: the original /datum/firemode we're firing on
	var/datum/firemode/firemode

	//* firing *//
	/// firing flags
	var/firing_flags
	/// firing atom
	///
	/// * this is not the same as actor event args; most things that care about this
	///   do not care about the actor tuple.
	var/atom/firing_atom
	/// actor tuple, if it exists.
	var/datum/event_args/actor/firing_actor
	/// how many iterations to fire
	///
	/// * defaulted to firemode settings
	var/firing_iterations = 1
	/// delay between firing iterations
	///
	/// * defaulted to firemode settings
	var/firing_delay = 0.2 SECONDS

	//*              fired processing args                 *//
	//* these are vars set in a given iteration of firing. *//
	/// last GUN_FIRED_* result
	var/last_firing_result
	/// were we interrupted?
	var/last_interrupted = FALSE

	//*                        firing modifier args                        *//
	//* this is where things like modular gun components will inject into. *//
	/// for all iterations, this is the base dispersion
	var/base_dispersion_adjust
	/// for all iterations, this is the base angle adjust (pos = cw, neg = ccw); this is in degrees
	var/base_angle_adjust
	/// current GUN_FIRED_* to inject; this is used to fail a cycle from a component signal
	/// by setting this on us.
	var/next_firing_fail_result
	/// on this iteration, have this much dispersion added
	var/next_dispersion_adjust
	/// on this iteration, force adjust the angle by this much (pos = cw, neg = ccw); this is in degrees
	var/next_angle_adjust
	/// energy cost multiplier for the projectile
	var/next_projectile_cost_multiplier = 1
	/// blackboard for modular gun components to use
	var/list/blackboard
	/// multiplier to total cooldown after firing cycle
	var/overall_cooldown_multiply = 1
	/// adjust to total cooldown after firing cycle
	var/overall_cooldown_adjust = 0

/datum/gun_firing_cycle/proc/finish_iteration(result)
	last_firing_result = result

	next_dispersion_adjust = \
	next_angle_adjust = \
	next_firing_fail_result = \
		null

	next_projectile_cost_multiplier = \
		1
