GLOBAL_LIST_INIT(dmm_orientations, list(
	TEXT_NORTH = new /datum/dmm_orientation/north,
	TEXT_SOUTH = new /datum/dmm_orientation/south,
	TEXT_EAST = new /datum/dmm_orientation/east,
	TEXT_WEST = new /datum/dmm_orientation/west
	))

/datum/dmm_orientation
	var/invert_x
	var/invert_y
	var/swap_xy
	var/xi
	var/yi
	var/turn_angle

/datum/dmm_orientation/north
	invert_y = TRUE
	invert_x = TRUE
	swap_xy = FALSE
	xi = -1
	yi = 1
	turn_angle = 180

/datum/dmm_orientation/south
	invert_y = FALSE
	invert_x = FALSE
	swap_xy = FALSE
	xi = 1
	yi = -1
	turn_angle = 0

/datum/dmm_orientation/east
	invert_y = TRUE
	invert_x = FALSE
	swap_xy = TRUE
	xi = 1
	yi = 1
	turn_angle = 90

/datum/dmm_orientation/west
	invert_y = FALSE
	invert_x = TRUE
	swap_xy = TRUE
	xi = -1
	yi = -1
	turn_angle = 270

// for looking up dir from south to turn angle
GLOBAL_REAL_LIST(dmm_orientation_turn) = list(
	180, // north
	0, // south
	0,
	90, // east
	0,
	0,
	0,
	270, // west
)
