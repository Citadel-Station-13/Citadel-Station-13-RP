/mob/observer/eye/Life(seconds, times_fired)
	if((. = ..()))
		return
	// If we lost our client, reset the list of visible chunks so they update properly on return
	if(owner == src && !client)
		visibleChunks.Cut()
	/*else if(owner && !owner.client)
		visibleChunks.Cut()*/
