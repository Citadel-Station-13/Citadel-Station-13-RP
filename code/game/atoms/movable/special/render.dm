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

/**
 * For damage ticks
 */
/atom/movable/render/damage_tick
	maptext_height = 128
	maptext_width = 128
	maptext_x = -48
	maptext_y = 16

/atom/movable/render/damage_tick/Initialize(mapload, atom/movable/bind_to, duration)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-2, 10)
	if(bind_to)
		pixel_x += bind_to.step_x + bind_to.pixel_x
		pixel_y += bind_to.step_y + bind_to.pixel_y
	animate(
		src,
		time = duration * 0.75,
		pixel_y = pixel_y + 16,
	)
	QDEL_IN(src, duration > 0 ? duration : (0.5 SECONDS))

/atom/movable/render/damage_tick/Destroy()
	vis_locs.len = 0
	return ..()
