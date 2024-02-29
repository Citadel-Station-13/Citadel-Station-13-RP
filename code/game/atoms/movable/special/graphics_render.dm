/**
 * holds render effects / otherwise just acts like it isn't there other than its visual impacts
 */
/atom/movable/graphics_render
	appearance_flags = KEEP_TOGETHER
	atom_flags = ATOM_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/graphics_render/doMove()
	CRASH("someone tried to move us normally")

/atom/movable/graphics_render/Move()
	CRASH("someone tried to move us normally")
