/atom/movable/screen/waypoint_tracker
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "CENTER"
	/// current visible?
	var/visible = TRUE


#warn impl

/**
 * angle is natural math angle, as in deg clockwise of east
 * NOT "byond angle".
 */
/atom/movable/screen/waypoint_tracker/proc/set_angle(angle)

/**
 * sets if we're invis/disabled
 */
/atom/movable/screen/waypoint_tracker/proc/set_disabled(v)
	if(v == visible)
		return
	visible = v
	if(visible)
		screen_loc = "CENTER"
	else
		screen_loc = null

/atom/movable/screen/waypoint_tracker/gps
