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
	reset_angle(0)

/**
 * angle is natural math angle, as in deg clockwise of east
 * NOT "byond angle".
 */
/atom/movable/screen/waypoint_tracker/proc/set_angle(angle)
	var/matrix/M = transform
	M.TurnTo(last_angle, angle)
	transform = M
	last_angle = angle

/**
 * resets transform
 *
 * angle is natural math angle, as in deg clockwise of east
 * NOT "byond angle".
 */
/atom/movable/screen/waypoint_tracker/proc/reset_angle(angle)
	var/matrix/M = matrix()
	M.Translate(dist, 0)
	M.Scale(size, size)
	M.Turn(-angle)
	transform = M
	last_angle = 0

/**
 * sets if we're invis/disabled
 */
/atom/movable/screen/waypoint_tracker/proc/set_disabled(v)
	if((!v) == visible)
		return
	visible = v
	if(visible)
		screen_loc = "CENTER"
	else
		screen_loc = null

/atom/movable/screen/waypoint_tracker/gps
	icon = 'icons/screen/objects/arrows_32.dmi'
	icon_state = "europa1"
	icon_dimension_x = 48
	icon_dimension_y = 48
	dist = 128
	alpha = 128
	size = 0.5
	color = rgb(177, 177, 255)
