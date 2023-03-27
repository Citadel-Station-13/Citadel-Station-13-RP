/mob/living/update_mobility(blocked, forced)
	if(dead)
		blocked |= MOBILITY_FLAGS_REAL | MOBILITY_CONSCIOUS
		return ..()
	if(restrained())
		blocked |= MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_HOLD | MOBILITY_PULL | MOBILITY_STORAGE | MOBILITY_UI
		if(pulledby || buckled)
			blocked |= MOBILITY_MOVE | MOBILITY_RESIST

	. = ..()

	if(!(mobility_flags & MOBILITY_HOLD))
		drop_all_held_items()
	if(!(mobility_flags & MOBILITY_PULL))
		stop_pulling()

#warn impl

/mob/living/proc/toggle_resting(value, instant)
	#warn impl

/mob/living/proc/set_resting(value, instant)
	#warn impl

/mob/living/proc/resist_a_rest()
	#warn impl

/mob/living/proc/set_intentionally_resting(value, instant)



#warn refactor

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	toggle_resting()
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")
	update_canmove()
