// Ok ok I know it says update_icon but this actually has everything from //
// update_appearance to update_transform and others.                      //

// todo: rework UPDATE_ICON flags or something for "should we transform"

/**
 * Our transform is reset at the base of /atom/movable/proc/update_transform()
 */
/atom/movable/proc/update_transform()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/matrix/new_transform = matrix()
	var/matrix/old_transform = transform

	base_transform(new_transform)
	apply_transform(new_transform)

	SEND_SIGNAL(src, COMSIG_MOVABLE_ON_UPDATE_TRANSFORM, old_transform, new_transform)

/atom/movable/proc/apply_transform(matrix/to_apply)
	SHOULD_NOT_SLEEP(TRUE)
	transform = to_apply

/**
 * Changing the transform before ..() and after ..() is allowed.
 *
 * @return the matrix to apply.
 */
/atom/movable/proc/base_transform(matrix/applying)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	applying.Scale(icon_scale_x, icon_scale_y)
	applying.Turn(icon_rotation)
	SEND_SIGNAL(src, COMSIG_MOVABLE_BASE_TRANSFORM, applying)
	return applying

/**
 * Immediate transform modify.
 *
 * todo: this should use apply_transform and use update icon flags or something, like NO_ANIMATIONS
 */
/atom/movable/proc/set_transform(matrix/new_transform)
	var/matrix/old_transform = transform
	src.transform = new_transform
	SEND_SIGNAL(src, COMSIG_MOVABLE_ON_UPDATE_TRANSFORM, old_transform, new_transform)
