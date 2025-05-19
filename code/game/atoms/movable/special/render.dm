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
	pixel_x = rand(-8, 8)
	pixel_y = rand(-2, 4)
	// extremely fancy stuff: if bind_to is moving, estimate where they are
	if(bind_to)
		if(bind_to.last_move > world.time - (world.tick_lag * (WORLD_ICON_SIZE / (bind_to.glide_size || 8))))
			var/diff = bind_to.glide_size * ((world.time - last_move) / world.tick_lag)
			if(bind_to.last_move_dir & NORTH)
				pixel_y -= WORLD_ICON_SIZE - diff
			else if(bind_to.last_move_dir & SOUTH)
				pixel_y += WORLD_ICON_SIZE - diff
			if(bind_to.last_move_dir & EAST)
				pixel_x += WORLD_ICON_SIZE - diff
			else if(bind_to.last_move_dir & WEST)
				pixel_x -= WORLD_ICON_SIZE - diff
	animate(
		src,
		time = duration * 0.5,
		pixel_y = 16,
	)
	QDEL_IN(src, duration > 0 ? duration : (0.5 SECONDS))

/atom/movable/render/damage_tick/Destroy()
	vis_locs.len = 0
	return ..()
