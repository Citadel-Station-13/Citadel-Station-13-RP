// Ok ok I know it says update_icon but this actually has everything from //
// update_appearance to update_transform and others.                      //

/**
 * Our transform is reset at the base of /atom/movable/proc/update_transform()
 */
/atom/movable/proc/update_transform()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Turn(icon_rotation)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UPDATE_TRANSFORM, M)
	src.transform = M
