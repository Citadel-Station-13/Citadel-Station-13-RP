/mob/observer/dead/Move(NewLoc, direct)
	if(updatedir)
		set_dir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own
	var/oldloc = loc

	if(NewLoc)
		force_move(NewLoc)
/*
		update_parallax_contents()
*/
	else
		force_move(get_turf(src))  //Get out of closets and such as a ghost
		if((direct & NORTH) && y < world.maxy)
			y++
		else if((direct & SOUTH) && y > 1)
			y--
		if((direct & EAST) && x < world.maxx)
			x++
		else if((direct & WEST) && x > 1)
			x--
	Moved(oldloc, direct, FALSE)

/mob/observer/dead/Process_Spacemove(dir)
	return TRUE		//we don't drift.

/mob/observer/dead/canface()
	return TRUE
