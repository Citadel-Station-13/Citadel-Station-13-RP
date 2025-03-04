/**
 * holds render effects / otherwise just acts like it isn't there other than its visual impacts
 */
/atom/movable/render
	SET_APPEARANCE_FLAGS(PIXEL_SCALE | KEEP_TOGETHER)
	atom_flags = ATOM_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = NONE

/atom/movable/render/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_INITIALIZED
	return INITIALIZE_HINT_NORMAL

/**
 * For particles
 */
/atom/movable/render/particle
