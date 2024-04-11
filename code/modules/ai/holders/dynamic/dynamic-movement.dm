//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * We have three main modes of movement:
 *
 * * Combat - the combat loop handles movement
 * * Navigation - the navigation loop handles movement
 * * Idle - the idle loop handles movement
 */
/datum/ai_holder/dynamic

/datum/ai_holder/dynamic/move(times_fired)
	// todo: optimize.
	if(move_special(times_fired, mode, state))
		return
	if(navigation_active)
		#warn impl
	switch(mode)
		if(AI_DYNAMIC_MODE_PASSIVE)
			if(AI_DYNAMIC_STATE_IDLE)
				// idle_loop() handles idle behaviors.
				return 0
			if(AI_DYNAMIC_STATE_PATROL, AI_DYNAMIC_STATE_NAVIGATION)
				#warn navigation
			if(AI_DYNAMIC_STATE_ESCALATION)
				#warn hold still & threaten?
		if(AI_DYNAMIC_MODE_COMBAT)
			switch(state)
				if(AI_DYNAMIC_STATE_FLANK, AI_DYNAMIC_STATE_RETREAT)
					#warn navigation
				else
					#warn combat loop
		if(AI_DYNAMIC_MODE_DISABLED)
			// why are we here?
			stack_trace("moving while disabled")
			return 0
	stack_trace("fell through state machine")
	return 0

/**
 * schedule a dodge in a certain direction
 *
 * if time is 0:
 * * if we're ready to move right now, we will
 * * if we're not, we move when we are
 *
 * usually done when the ai has detected an inbound attack
 */
/datum/ai_holder/dynamic/proc/schedule_dodge(dir, time)


#warn impl
