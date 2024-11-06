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

	//* targeting *//
	/// original target
	var/atom/original_target
	/// original angle
	var/original_angle

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
