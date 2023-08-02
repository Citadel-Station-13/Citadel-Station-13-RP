/atom/movable/screen/waypoint_tracker
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "CENTER"
	/// current visible?
	var/visible = TRUE
	/// distance from center
	var/dist = 96
	/// size transform
	var/size = 1
	/// last angle
	var/last_angle

/atom/movable/screen/waypoint_tracker/Initialize(mapload)
	. = ..()
	reset_angle()

/**
 * angle is natural math angle, as in deg clockwise of east
 * NOT "byond angle".
 */
/atom/movable/screen/waypoint_tracker/proc/set_angle(angle)
	if(last_angle == angle)
		return
	var/matrix/M = transform
	// 360 - angle because byond is weird
	// and arctan operates off irl angles (CCW of EAST)
	// but byond angle sare usually CW; we reset to EAST
	// because we're stubborn thus we convert it
	// thus, we go in reverse.
	angle = 360 - angle
	M.TurnTo(last_angle, angle)
	transform = M
	last_angle = angle

/**
 * resets transform
 *
 * angle is natural math angle, as in deg clockwise of east
 * NOT "byond angle".
 */
/atom/movable/screen/waypoint_tracker/proc/reset_angle()
	var/matrix/M = matrix()
	// turn to math deg 0
	M.Turn(90)
	// scale properly
	M.Scale(size, size)
	// move out
	M.Translate(dist, 0)
	// set
	transform = M
	// track angle for fast turns
	last_angle = 0

/**
 * sets if we're invis/disabled
 */
/atom/movable/screen/waypoint_tracker/proc/set_disabled(v)
	if((!v) == visible)
		return
	visible = !v
	if(visible)
		screen_loc = "CENTER"
	else
		screen_loc = null

/atom/movable/screen/waypoint_tracker/gps
	icon = 'icons/screen/objects/arrows_32.dmi'
	icon_state = "europa1"
	icon_x_dimension = 48
	icon_y_dimension = 48
	dist = 128
	alpha = 128
	size = 2 / 3
