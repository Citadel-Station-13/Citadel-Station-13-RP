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
