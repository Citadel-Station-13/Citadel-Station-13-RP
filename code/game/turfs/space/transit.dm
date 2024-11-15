/turf/space/transit
	dir = SOUTH
	can_build_into_floor = FALSE

// Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O as obj, mob/user as mob)
	return

/turf/space/transit/north	// Moving to the north
	dir = NORTH
	icon_state = "arrow-north"

/turf/space/transit/south	// Moving to the south
	dir = SOUTH
	icon_state = "arrow-south"

/turf/space/transit/east	// Moving to the east
	dir = EAST
	icon_state = "arrow-east"

/turf/space/transit/west	// Moving to the west
	dir = WEST
	icon_state = "arrow-west"
