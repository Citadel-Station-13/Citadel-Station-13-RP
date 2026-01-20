//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/airlock_cycle/vacuum_cycle
	var/to_side = AIRLOCK_SIDE_NEUTRAL

/datum/airlock_cycle/vacuum_cycle/New(set_to_side)
	if(set_to_side)
		src.to_side = set_to_side
	..()

/datum/airlock_cycle/vacuum_cycle/setup()
	enqueue_phase(new /datum/airlock_phase/doors/seal)
	switch(side_cycling_from)
		if(AIRLOCK_SIDE_EXTERIOR)
			// TODO: required is silly, but the majority of citrp's airlocks would horribly clog
			//       if outside air was pumped to scrubber; that, and, most setups aren't
			//       equipped to properly clean potentially dirty air
			enqueue_phase(new /datum/airlock_phase/depressurize/vent_to_outside/required)
		else
			// If interior, always go to handler waste, not outside
			enqueue_phase(new /datum/airlock_phase/depressurize)
	enqueue_phase(new /datum/airlock_phase/repressurize)
	var/datum/airlock_phase/unseal_step
	switch(to_side)
		if(AIRLOCK_SIDE_EXTERIOR)
			unseal_step = new /datum/airlock_phase/doors/unseal/exterior
		if(AIRLOCK_SIDE_INTERIOR)
			unseal_step = new /datum/airlock_phase/doors/unseal/interior
		if(AIRLOCK_SIDE_NEUTRAL)
			/// this does nothing and just keeps the airlock closed, and is considered a legal
			/// operation to perform.
		else
			STACK_TRACE("unknown side '[to_side]'")
	if(unseal_step)
		enqueue_phase(unseal_step)
