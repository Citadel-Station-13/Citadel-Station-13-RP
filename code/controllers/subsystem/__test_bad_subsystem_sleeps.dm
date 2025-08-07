//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Used to intentionally fuck up the MC fire() by sleeping ridiculous
 * amounts of time.
 *
 * Used to test sleep handling and stage change behavior.
 *
 * **This file should not be ticked outside of special development testing.**
 */
#warn Bad subsystem sleep tester is ticked.

SUBSYSTEM_DEF(__test_bad_subsystem_sleeps)
	name = "-- TEST BAD SUBSYSTEM SLEEPS --"
	init_stage = INIT_STAGE_BACKEND
	init_order = 100 // this doesn't matter tbh; what matters is it runs as soon as possible so the test goes faster
	subsystem_flags = SS_NO_INIT
	runlevels = RUNLEVELS_ALL

	var/is_currently_sleeping = FALSE
	var/should_resume = FALSE
	var/first_fire = TRUE
	var/mc_init_stage_at_start_of_sleep

/datum/controller/subsystem/__test_bad_subsystem_sleeps/fire(resumed)
	if(first_fire)
		is_currently_sleeping = TRUE
		mc_init_stage_at_start_of_sleep = Master.init_stage_ticking
		sleep(10 SECONDS)
		is_currently_sleeping = FALSE
		if(mc_init_stage_at_start_of_sleep != Master.init_stage_ticking)
			CRASH("master controller moved on when we were trying to block init")
		should_resume = TRUE
		pause()
		return
	if(is_currently_sleeping)
		CRASH("re-fired while sleeping")
	if(!resumed && should_resume)
		CRASH("wasn't resumed when we should resume")
	if(resumed)
		should_resume = FALSE
		if(mc_init_stage_at_start_of_sleep != Master.init_stage_ticking)
			CRASH("master controller moved on when we were trying to block init")
