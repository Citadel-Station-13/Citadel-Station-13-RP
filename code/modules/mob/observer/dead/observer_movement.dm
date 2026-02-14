/mob/observer/dead/Move(NewLoc, direct, step_x, step_y, glide_size_override = 32)
	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own

	if(glide_size_override)
		set_glide_size(glide_size_override)
	if(NewLoc)
		abstract_move(NewLoc)
	else
		var/turf/destination = get_turf(src)

		if((direct & NORTH) && y < world.maxy)
			destination = get_step(destination, NORTH)

		else if((direct & SOUTH) && y > 1)
			destination = get_step(destination, SOUTH)

		if((direct & EAST) && x < world.maxx)
			destination = get_step(destination, EAST)

		else if((direct & WEST) && x > 1)
			destination = get_step(destination, WEST)

		abstract_move(destination)//Get out of closets and such as a ghost

/mob/observer/dead/forceMove(atom/destination)
	abstract_move(destination) // move like the wind
	return TRUE

// Ghosts have no momentum, being massless ectoplasm
/mob/observer/dead/Process_Spacemove(movement_dir)
	return TRUE

/mob/observer/dead/canface()
	return TRUE

/mob/observer/dead/CanAllowThrough(atom/movable/mover, turf/target)
	return TRUE // ghosts don't block
