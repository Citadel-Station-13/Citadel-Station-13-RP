/mob/living/update_mobility(blocked, forced)
	if(restrained())
		blocked |= MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_HOLD | MOBILITY_PULL | MOBILITY_STORAGE | MOBILITY_UI
		if(pulledby || buckled)
			blocked |= MOBILITY_MOVE | MOBILITY_RESIST

	. = ..(blocked, forced)

	if(!(mobility_flags & MOBILITY_HOLD))
		drop_all_held_items()
	if(!(mobility_flags & MOBILITY_PULL))
		stop_pulling()

#warn impl

/mob/living/proc/toggle_resting()
	#warn impl

/mob/living/proc/set_resting(value)
	#warn impl

#warn delays on getting up
