//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * creates a segmenting beam
 *
 * you must delete this beam yourself, unlike legacy beams
 *
 * @params
 * * source - where to draw from
 * * target - where to draw to
 * * collider_type - set to a type to create colliders
 * * icon - beam icon
 * * icon_state - beam icon state
 * * emissive_state - emissive overlay to use
 */
/proc/create_segmented_beam(atom/source, atom/target, collider_type, icon, icon_state, emissive_state)
	var/datum/beam/created = new(source, target)
	if(!isnull(collider_type))
		created.collider_type = collider_type
		created.colliders = TRUE
	created.icon = icon
	created.icon_state = icon_state
	created.emissive_state = emissive_state
	created.beam_visual_mode = BEAM_VISUAL_SEGMENTS
	created.initialize()
	return created

/**
 * creates a stretching beam
 *
 * you must delete this beam yourself, unlike legacy beams
 *
 * @params
 * * source - where to draw from
 * * target - where to draw to
 * * collider_type - set to a type to create colliders
 * * icon - beam icon
 * * icon_state - beam icon state
 * * emissive_state - emissive overlay to use
 */
/proc/create_stretched_beam(atom/source, atom/target, collider_type, icon, icon_state, emissive_state)
	var/datum/beam/created = new(source, target)
	if(!isnull(collider_type))
		created.collider_type = collider_type
		created.colliders = TRUE
	created.icon = icon
	created.icon_state = icon_state
	created.emissive_state = emissive_state
	created.beam_visual_mode = BEAM_VISUAL_STRETCH
	created.initialize()
	return created

/**
 * creates a beam that... doesn't render (lmao)
 *
 * you must delete this beam yourself, unlike legacy beams
 *
 * @params
 * * source - where to draw from
 * * target - where to draw to
 * * collider_type - set to a type to create colliders
 */
/proc/create_particle_beam(atom/source, atom/target, collider_type)
	var/datum/beam/created = new(source, target)
	if(!isnull(collider_type))
		created.collider_type = collider_type
		created.colliders = TRUE
	created.initialize()
	return created

/**
 * linear on-map line drawing datums
 *
 * can optionally handle colliders.
 *
 * * beam_source, beam_target are both get_turf()'d. it is *your* job to handle whether or not this is valid
 * * beam drawing is event-driven. it doesn't redraw unless necessary.
 */
/datum/beam
	//* basics *//
	/// source
	var/atom/beam_source
	/// target
	var/atom/beam_target
	/// do not automatically redraw on things moving
	var/no_automatic_redraw = FALSE

	//* collision *//
	/// requires collision
	var/colliders = FALSE
	/// collider type to use
	var/collider_type
	/// registered colliding entities, turf or movable; only made as a list if collision or segment mode is enabled
	var/list/atom/colliding
	/// colliders
	var/list/atom/movable/beam_collider/colliders

	//* segmentation *//
	/// beam segment holder
	var/atom/movable/beam_segments/segmentation
	/// beam segment holder
	var/atom/movable/beam_segments/emissive/emissive_segmentation

	//* graphics *//
	/// graphics mode
	var/beam_visual_mode
	/// icon to use in non-particle mode
	var/icon
	/// state to use in non-particle mode
	var/icon_state
	/// emissive state to use in non-particle mode
	var/emissive_state
	/// if we are in stretch mode, this is our rendering line
	var/atom/movable/graphics_render/beam_line/line_renderer
	/// if we are in stretch mode, this is our emissive rendering line
	var/atom/movable/graphics_render/beam_line/emissive/emissive_line_renderer
	/// if we are in particle mode, this is our renderer
	var/atom/movable/particle_render/beam_line/particle_renderer
	/// if we are in particle mode, this is our emissive renderer
	var/atom/movable/particle_render/beam_line/emissive/emissive_particle_renderer
	/// if we are in particle mode, this is the particle instance we use.
	var/particles/particle_reference
	/// if we are in particle mode, tihs is the emissive particle instance we use.
	var/particles/emissive_particle_reference

/datum/beam/New(atom/source, atom/target)
	src.beam_source = source
	src.beam_target = target
	register()

/datum/beam/Destroy()
	unregister()
	return ..()

/datum/beam/proc/register()
	var/atom/iterating
	// register signal hooks for movement all the way up the stack to the top level atom
	if(ismovable(beam_source))
		iterating = beam_source
		do
			RegisterSignal(iterating, COMSIG_MOVABLE_MOVED, PROC_REF(signal_redraw))
			iterating = iterating.loc
		while(ismovable(iterating))
	if(ismovable(beam_target))
		iterating = beam_source
		do
			RegisterSignal(iterating, COMSIG_MOVABLE_MOVED, PROC_REF(signal_redraw))
			iterating = iterating.loc
		while(ismovable(iterating))

/datum/beam/proc/unregister()
	var/atom/iterating
	// drop signal hooks for movement all the way up the stack to the top level atom
	if(ismovable(beam_source))
		iterating = beam_source
		do
			UnregisterSignal(iterating, COMSIG_MOVABLE_MOVED)
			iterating = iterating.loc
		while(ismovable(iterating))
	if(ismovable(beam_target))
		iterating = beam_target
		do
			UnregisterSignal(iterating, COMSIG_MOVABLE_MOVED)
			iterating = iterating.loc
		while(ismovable(iterating))

/datum/beam/proc/initialize()
	// for any modes with emissives, the emissive is shoved into the main renderer
	// and the entire thing is KT-group'd together.
	switch(beam_visual_mode)
		if(BEAM_VISUAL_SEGMENTS)
			segmentation = new
			emissive_segmentation = new
		if(BEAM_VISUAL_STRETCH)
			line_renderer = new
			line_renderer.icon = icon
			line_renderer.icon_state = icon_state
			if(!isnull(emissive_state))
				emissive_line_renderer = new
				emissive_line_renderer.icon = icon
				emissive_line_renderer.icon_state = emissive_state

	if(colliders)
		LAZYINITLIST(colliders)
		LAZYINITLIST(colliding)

	force_redraw()

/datum/beam/proc/force_redraw()
	var/turf/start = get_turf(beam_source)
	var/turf/end = get_turf(beam_target)
	var/spx = 0
	var/spy = 0
	var/epx = 0
	var/epy = 0
	if(isturf(beam_source.loc))
		var/atom/movable/movable_source = beam_source
		spx = movable_source.get_centering_pixel_x_offset
		spy = movable_source.pixel_y
	if(isturf(beam_target.loc))
		var/atom/movable/movable_target = beam_target
		epx = movable_target.pixel_x
		epy = movable_target.pixel_y
	render(start, spx, spy, end, epx, epy)

/datum/beam/proc/signal_redraw(atom/movable/source, atom/old_loc, dir, forced, list/old_locs, momentum_change)
	if(ismovable(old_loc))
		// get old turf
		var/turf/was_at = get_turf(old_loc)
		// signal was emitted on an intermediate object instead of top level; drop signals there
		var/atom/iterating
		iterating = old_loc
		do
			UnregisterSignal(iterating, COMSIG_MOVABLE_MOVED)
			iterating = iterating.loc
		while(ismovable(iterating))
		// and register to the new intermediate object, if any
		if(ismovable(source.loc))
			iterating = source.loc
			do
				RegisterSignal(iterating, COMSIG_MOVABLE_MOVED, PROC_REF(signal_redraw))
				iterating = iterating.loc
			while(ismovable(iterating))
		// get new turf
		var/turf/is_at = get_turf(source.loc)
		// if both turfs are the same, aka we were shifting internally, don't bother redrawing
		if(was_at == is_at)
			return
	// todo: optimize
	// for now i'm lazy so just do a hard draw instead of a cached draw of some kind
	force_redraw()

/datum/beam/proc/render(turf/start, start_px, start_py, turf/end, end_px, end_py)
	// calculate parameters
	var/dx = ((WORLD_ICON_SIZE * end.x + end_px) - (WORLD_ICON_SIZE * start.x + start_px))
	var/dy = ((WORLD_ICON_SIZE * end.y + end_py) - (WORLD_ICON_SIZE * start.y + start_py))
	var/north_of_east = arctan(dx, dy)
	var/distance = sqrt(dx ** 2 + dy ** 2)
	// draw
	switch(beam_visual_mode)
		#warn deal with particles
		// if(BEAM_VISUAL_PARTICLES)
		// 	// calculate matrix
		// 	var/matrix/transform_to_apply = matrix()
		// 	// rotate to clockwise-from-north as opposed to counterclockwise-from-east
		// 	transform_to_apply.Turn((-north_of_east) - 90)
		// 	// handle normal render
		// 	particle_renderer.loc = start
		// 	particle_renderer.transform = transform_to_apply
		// 	// handle emissive render
		// 	if(!isnull(emissive_particle_renderer))
		// 		emissive_particle_renderer.loc = start
		// 		emissive_particle_renderer.transform = transform_to_apply
		if(BEAM_VISUAL_SEGMENTS)
			// don't stretch past distance
			var/steps_required = round(distance / WORLD_ICON_SIZE)
			// we assume both segment renderers are lockstepped
			#warn impl
		if(BEAM_VISUAL_STRETCH)
			// calculate matrix
			var/matrix/transform_to_apply = matrix()
			// shift up so it's not in the way
			transform_to_apply.Translate(0, 16)
			// scale up the now shifted one so we don't have to translate post-scale
			transform_to_apply.Scale(1, distance / WORLD_ICON_SIZE)
			// rotate to clockwise-from-north as opposed to counterclockwise-from-east
			transform_to_apply.Turn((-north_of_east) - 90)
			// handle normal render
			line_renderer.loc = start
			line_renderer.transform = transform_to_apply
			// handle emissive render
			if(!isnull(emissive_line_renderer))
				emissive_line_renderer.loc = start
				emissive_line_renderer.transform = transform_to_apply
	// deal with colliders
	var/list/turf/colliding_turfs = getline(start, end)
	if(length(colliding_turfs) < colliders)
		// if more than needed, nullspace the rest but keep them on hand
		for(var/i in length(colliding_turfs) + 1 to length(collliders))
			var/atom/movable/beam_collider/collider = colliders[i]
			collider.move_onto(null)
	else if(length(colliding_turfs) > colliders)
		// if less than needed, make new ones but don't collide yet
		for(var/i in 1 to length(colliding_turfs) - length(colliders))
			colliders += new atom/movable/beam_collider(src)
	// we should be greater-or-equal colliders than turfs now
	// now-overallocated colliders are ignored and cached in nullspace
	// this system also enforces deterministic source-to-target propagation as opposed
	// to non-deterministic orderings.
	for(var/i in 1 to min(length(colliders), length(colliding_turfs)))
		var/atom/movable/beam_collider/collider = colliders[i]
		collider.move_onto(colliding_turfs[i])

/datum/beam/proc/uncrossed(atom/movable/entity)
	SHOULD_CALL_PARENT(TRUE)
	colliding -= entity

/datum/beam/proc/crossed(atom/movable/entity)
	SHOULD_CALL_PARENT(TRUE)
	colliding += entity

/**
 * adds a set of particles to this beam
 *
 * you have to control the particles yourself
 *
 * * the beam assumes that the particles will project in the **north** direction.
 * * this just makes the beam automatically rotate the particles as necessary.
 */
/datum/beam/proc/set_particles(particles/particle_reference, particles/emissive_particle_reference)
	if(isnull(particle_renderer))
		particle_renderer = new
	particle_renderer.particles = particle_reference
	if(!isnull(emissive_particle_reference))
		if(isnull(emissive_particle_renderer))
			emissive_particle_renderer = new
		emissive_particle_renderer.particles = emissive_particle_reference
	else if(!isnull(emissive_particle_renderer))
		QDEL_NULL(emissive_particle_renderer)
	force_redraw()

//* Segmented Renderers *//

/atom/movable/graphics_render/beam_segments
	appearance_flags = KEEP_TOGETHER

	/// segments in us
	var/list/mutable_appearance/segment_appearances = list()

/atom/movable/graphics_render/beam_segments/emissive
	plane = EMISSIVE_PLANE

//* Colliders *//

INITIALIZE_IMMEDIATE(/atom/movable/beam_collider)
/atom/movable/beam_collider
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT

	/// parent beam
	var/datum/beam/parent

/atom/movable/beam_collider/Initialize(mapload, datum/beam/parent)
	SHOULD_CALL_PARENT(FALSE)
	src.parent = parent
	atom_flags |= ATOM_INITIALIZED
	return INITIALIZE_HINT_NORMAL

/atom/movable/beam_collider/proc/move_onto(turf/where)
	for(var/atom/movable/other as anything in loc)
		if(other == src)
			continue
		if(other.atom_flags & ATOM_ABSTRACT)
			continue
		parent.uncrossed(other)
	loc = where
	for(var/atom/movable/other as anything in loc)
		if(other == src)
			continue
		if(other.atom_flags & ATOM_ABSTRACT)
			continue
		parent.crossed(other)

//* Stretched Renderers *//

/atom/movable/graphics_render/beam_line
	appearance_flags = KEEP_TOGETHER

/atom/movable/graphics_render/beam_line/emissive
	plane = EMISSIVE_PLANE

//* Particle Renderers *//

/atom/movable/particle_render/beam_line
	appearance_flags = KEEP_TOGETHER

/atom/movable/particle_render/beam_line/emissive
	plane = EMISSIVE_PLANE

/atom/movable/particle_render/beam_line/emissive/Initialize(mapload)
	ASSERT(istype(loc, /atom/movable/particle_render/beam_line))
	loc:vis_contents += src
	return ..()

/atom/movable/particle_render/beam_line/emissive/Destroy()
	ASSERT(istype(loc, /atom/movable/particle_render/beam_line))
	loc:vis_contents -= src
	return ..()
