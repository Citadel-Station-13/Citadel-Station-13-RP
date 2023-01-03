/atom/movable/screen/waypoint_tracker
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "CENTER"
	/// current visible?
	var/visible = TRUE
	/// distance from center
	var/dist = 96

/atom/movable/screen/waypoint_tracker/Initialize(mapload)
	. = ..()
	// center on, well, center
	auto_pixel_offset_to_center()
	// kick it to the edge of the tile, then x distance away
	pixel_x += dist + world.icon_size + -get_centering_pixel_x_offset()

/**
 * angle is natural math angle, as in deg clockwise of east
 * NOT "byond angle".
 */
/atom/movable/screen/waypoint_tracker/proc/set_angle(angle)
	var/matrix/M = matrix()
	M.Turn(-angle)
	transform = M

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
	icon = 'icons/screen/objetcs/arrows_32.dmi'
	icon_state = "europa1"
	icon_dimension_x = 48
	icon_dimension_y = 48
	dist = 128
	alpha = 128
	color = rgb(177, 177, 255)
