/**
 * holds render effects / otherwise just acts like it isn't there other than its visual impacts
 */
/atom/movable/render
	SET_APPEARANCE_FLAGS(PIXEL_SCALE)
	appearance_flags = KEEP_TOGETHER
	atom_flags = ATOM_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = NONE

/**
 * For particles
 */
/atom/movable/render/particle
