/mob/living/proc/reveal(var/silent, var/message = "<span class='warning'>You have been revealed! You are no longer hidden.</span>")
	if(status_flags & STATUS_HIDING)
		status_flags &= ~STATUS_HIDING
		reset_plane_and_layer()
		if(!silent && message)
			to_chat(src, message)

/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	// Check for has_buckled_mobs() (taur riding)
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_USE) || buckled || LAZYLEN(grabbed_by) || has_buckled_mobs())
		return

	if(status_flags & STATUS_HIDING)
		reveal("<span class='notice'>You have stopped hiding.</span>")
	else
		status_flags |= STATUS_HIDING
		set_base_layer(HIDING_LAYER)
		plane = OBJ_PLANE
		to_chat(src,"<span class='notice'>You are now hiding.</span>")
