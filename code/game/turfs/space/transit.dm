/turf/space/transit
	dir = SOUTH
	can_build_into_floor = FALSE
	var/pushdirection	// Push things that get caught in the transit tile this direction

/turf/space/transit/Initialize(mapload)
	. = ..()
	icon_state = "speedspace_ew_[get_trasnit_state(src)]"
	var/matrix/M = matrix()
	M.Turn(get_transit_angle(src))
	transform = M

// Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O as obj, mob/user as mob)
	return

/turf/space/transit/north	// Moving to the north
	dir = NORTH
	icon_state = "arrow-north"
	pushdirection = SOUTH	// South because the space tile is scrolling south

/turf/space/transit/south	// Moving to the south
	dir = SOUTH
	icon_state = "arrow-south"
	pushdirection = NORTH	// north because the space tile is scrolling north

/turf/space/transit/east	// Moving to the east
	dir = EAST
	icon_state = "arrow-east"
	pushdirection = WEST

/turf/space/transit/west	// Moving to the west
	dir = WEST
	icon_state = "arrow-west"
	pushdirection = WEST

//-----------------------


/proc/get_trasnit_state(turf/T)
	var/p = 9
	. = 1
	switch(T.dir)
		if(NORTH)
			. = ((-p*T.x+T.y) % 15) + 1
			if(. < 1)
				. += 15
		if(EAST)
			. = ((T.x+p*T.y) % 15) + 1
		if(WEST)
			. = ((T.x-p*T.y) % 15) + 1
			if(. < 1)
				. += 15
		else
			. = ((p*T.x+T.y) % 15) + 1

/proc/get_transit_angle(turf/T)
	. = 0
	switch(T.dir)
		if(NORTH)
			. = 180
		if(EAST)
			. = 90
		if(WEST)
			. = -90
