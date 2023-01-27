/mob/living/proc/reveal(var/silent, var/message = SPAN_WARNING("You have been revealed! You are no longer hidden."))
	if(status_flags & HIDING)
		status_flags &= ~HIDING
		reset_plane_and_layer()
		if(!silent && message)
			to_chat(src, message)

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	// Check for has_buckled_mobs() (taur riding)
	if(stat == DEAD || paralysis || weakened || stunned || restrained() || buckled || LAZYLEN(grabbed_by) || has_buckled_mobs())
		return

	if(status_flags & HIDING)
		reveal(SPAN_NOTICE("You have stopped hiding."))
	else
		status_flags |= HIDING
		set_base_layer(HIDING_LAYER)
		plane = OBJ_PLANE
		to_chat(src,SPAN_NOTICE("You are now hiding."))
