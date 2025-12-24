//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
	/// listener for source
	var/datum/beam_listener/listener_source
	/// listener for target
	var/datum/beam_listener/listener_target
	/// distance to bias towards target from source
	var/shift_start_towards_target = 0
	/// distance to bias towards source from target
	var/shift_end_towards_source = 0
	/// do not automatically redraw on things moving
	var/no_automatic_redraw = FALSE

	//* collision *//
	/// collider type to use
	var/collider_type
	/// registered colliding entities, turf or movable; only made as a list if collision or segment mode is enabled
	var/list/atom/colliding
	/// colliders
	var/list/atom/movable/beam_collider/colliders

	//* segmentation *//
	/// beam segment holder
	var/atom/movable/render/beam_segments/segmentation
	/// beam segment holder
	var/atom/movable/render/beam_segments/emissive/emissive_segmentation

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
	var/atom/movable/render/beam_line/line_renderer
	/// if we are in stretch mode, this is our emissive rendering line
	var/atom/movable/render/beam_line/emissive/emissive_line_renderer
	/// if we are in particle mode, this is our renderer
	var/atom/movable/render/particle/beam_line/particle_renderer
	/// if we are in particle mode, this is our emissive renderer
	var/atom/movable/render/particle/beam_line/emissive/emissive_particle_renderer
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
	beam_source = null
	beam_target = null
	// get rid of emissives first
	QDEL_NULL(emissive_line_renderer)
	QDEL_NULL(line_renderer)
	QDEL_NULL(emissive_particle_renderer)
	QDEL_NULL(particle_renderer)
	QDEL_NULL(emissive_segmentation)
	QDEL_NULL(segmentation)
	// get rid of colliders
	QDEL_LIST_NULL(colliders)
	return ..()

/datum/beam/proc/register()
	listener_source = new(src, beam_source)
	listener_target = new(src, beam_target)

/datum/beam/proc/unregister()
	QDEL_NULL(listener_source)
	QDEL_NULL(listener_target)

/datum/beam/proc/initialize()
	// for any modes with emissives, the emissive is shoved into the main renderer
	// and the entire thing is KT-group'd together.
	switch(beam_visual_mode)
		if(BEAM_VISUAL_SEGMENTS)
			segmentation = new
			segmentation.icon = icon
			if(!isnull(emissive_state))
				emissive_segmentation = new(segmentation)
				emissive_segmentation.icon = icon
		if(BEAM_VISUAL_STRETCH)
			line_renderer = new
			line_renderer.icon = icon
			line_renderer.icon_state = icon_state
			if(!isnull(emissive_state))
				emissive_line_renderer = new(line_renderer)
				emissive_line_renderer.icon = icon
				emissive_line_renderer.icon_state = emissive_state

	if(collider_type)
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
		spx = movable_source.pixel_x
		spy = movable_source.pixel_y
	if(isturf(beam_target.loc))
		var/atom/movable/movable_target = beam_target
		epx = movable_target.pixel_x
		epy = movable_target.pixel_y
	render(start, spx, spy, end, epx, epy)
	SEND_SIGNAL(src, COMSIG_BEAM_REDRAW)

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
	// nah.
	if(start.z != end.z || start == end)
		switch(beam_visual_mode)
			if(BEAM_VISUAL_SEGMENTS)
				segmentation?.loc = emissive_segmentation?.loc = null
			if(BEAM_VISUAL_STRETCH)
				line_renderer?.loc = emissive_line_renderer?.loc = null
		particle_renderer?.loc = null
		for(var/atom/movable/beam_collider/collider as anything in colliders)
			collider.move_onto(null)
		return FALSE
	// calculate parameters
	var/dx = ((WORLD_ICON_SIZE * end.x + end_px) - (WORLD_ICON_SIZE * start.x + start_px))
	var/dy = ((WORLD_ICON_SIZE * end.y + end_py) - (WORLD_ICON_SIZE * start.y + start_py))
	// cw from north
	var/angle = arctan(dy, dx)
	// do biases
	// todo: is there is a better way to do this
	if(shift_start_towards_target)
		var/x_amt = shift_start_towards_target * sin(angle)
		var/y_amt = shift_start_towards_target * cos(angle)
		start_px += x_amt
		start_py += y_amt
		dx -= x_amt
		dy -= y_amt
	if(shift_end_towards_source)
		var/x_amt = shift_end_towards_source * sin(angle)
		var/y_amt = shift_end_towards_source * cos(angle)
		end_px -= x_amt
		end_py -= y_amt
		dx -= x_amt
		dy -= y_amt
	// dist in pixels
	var/distance = sqrt(dx ** 2 + dy ** 2)
	// draw
	switch(beam_visual_mode)
		if(BEAM_VISUAL_SEGMENTS)
			// don't stretch past distance
			var/steps_required = CEILING(distance / WORLD_ICON_SIZE, 1)
			// we assume both segment renderers are lockstepped
			var/requires_update = FALSE
			if(steps_required > length(segmentation.segment_appearances))
				requires_update = TRUE
				var/start_from_pixel = length(segmentation.segment_appearances) * WORLD_ICON_SIZE
				for(var/i in 1 to steps_required - length(segmentation.segment_appearances))
					var/image/injecting = image(icon_state = icon_state)
					injecting.pixel_y = i * WORLD_ICON_SIZE - (WORLD_ICON_SIZE * 0.5) + start_from_pixel
					segmentation.segment_appearances += injecting
				if(!isnull(emissive_segmentation))
					for(var/i in 1 to steps_required - length(emissive_segmentation.segment_appearances))
						var/image/emissive_injecting = image(icon_state = emissive_state)
						emissive_injecting.pixel_y = i * WORLD_ICON_SIZE - (WORLD_ICON_SIZE * 0.5) + start_from_pixel
						emissive_segmentation.segment_appearances += emissive_injecting
			else if(steps_required < length(segmentation.segment_appearances))
				requires_update = TRUE
				segmentation.segment_appearances.len = steps_required
				emissive_segmentation?.segment_appearances.len = steps_required
			if(requires_update)
				segmentation.overlays = segmentation.segment_appearances
				emissive_segmentation?.overlays = emissive_segmentation?.segment_appearances
			// calculate matrix
			var/matrix/transform_to_apply = matrix()
			// transform as necessary to shrink just enough to cut off extra pixels
			// todo: please use an alphamask filter on last element maybe, this looks like shit
			transform_to_apply.Scale(1, distance / (steps_required * WORLD_ICON_SIZE))
			// rotate
			transform_to_apply.Turn(angle)
			// move renders to location
			segmentation.forceMove(start)
			segmentation.pixel_x = start_px
			segmentation.pixel_y = start_py
			segmentation.transform = transform_to_apply
		if(BEAM_VISUAL_STRETCH)
			// calculate matrix
			var/matrix/transform_to_apply = matrix()
			// shift up so it's not in the way
			transform_to_apply.Translate(0, 16)
			// scale up the now shifted one so we don't have to translate post-scale
			transform_to_apply.Scale(1, distance / WORLD_ICON_SIZE)
			// rotate
			transform_to_apply.Turn(angle)
			// handle normal render
			line_renderer.forceMove(start)
			line_renderer.pixel_x = start_px
			line_renderer.pixel_y = start_py
			line_renderer.transform = transform_to_apply
	// deal with colliders
	if(!isnull(collider_type))
		var/list/turf/colliding_turfs = getline(start, end)
		if(length(colliding_turfs) < colliders)
			// if more than needed, nullspace the rest but keep them on hand
			for(var/i in length(colliding_turfs) + 1 to length(colliders))
				var/atom/movable/beam_collider/collider = colliders[i]
				collider.move_onto(null)
		else if(length(colliding_turfs) > colliders)
			// if less than needed, make new ones but don't collide yet
			for(var/i in 1 to length(colliding_turfs) - length(colliders))
				colliders += new /atom/movable/beam_collider(src)
		// we should be greater-or-equal colliders than turfs now
		// now-overallocated colliders are ignored and cached in nullspace
		// this system also enforces deterministic source-to-target propagation as opposed
		// to non-deterministic orderings.
		for(var/i in 1 to min(length(colliders), length(colliding_turfs)))
			var/atom/movable/beam_collider/collider = colliders[i]
			collider.move_onto(colliding_turfs[i])
	// deal with particles
	if(!isnull(particle_renderer))
		// calculate matrix
		var/matrix/transform_to_apply = matrix()
		// rotate
		transform_to_apply.Turn(angle)
		// move renders to location
		particle_renderer.forceMove(start)
		particle_renderer.pixel_x = start_px
		particle_renderer.pixel_y = start_py
		particle_renderer.transform = transform_to_apply

/datum/beam/proc/uncrossed(atom/movable/entity)
	SHOULD_CALL_PARENT(TRUE)
	colliding -= entity
	SEND_SIGNAL(src, COMSIG_BEAM_UNCROSSED, entity)

/datum/beam/proc/crossed(atom/movable/entity)
	SHOULD_CALL_PARENT(TRUE)
	colliding += entity
	SEND_SIGNAL(src, COMSIG_BEAM_CROSSED, entity)

/**
 * adds a set of particles to this beam
 *
 * you have to control the particles yourself
 *
 * * the beam assumes that the particles will project in the **north** direction.
 * * this just makes the beam automatically rotate the particles as necessary.
 * * if you pass in 'TRUE' as emissive_particle_renderer, emissives will render_source from the main particle system.
 */
/datum/beam/proc/set_particles(particles/particle_reference, particles/emissive_particle_reference)
	if(isnull(particle_renderer))
		particle_renderer = new
	particle_renderer.particles = particle_reference
	if(!isnull(emissive_particle_reference))
		if(isnull(emissive_particle_renderer))
			emissive_particle_renderer = new
		if(emissive_particle_reference == TRUE)
			particle_renderer.ensure_render_target()
			emissive_particle_renderer.render_source = particle_renderer.render_target
		else
			emissive_particle_renderer.particles = emissive_particle_reference
	else if(!isnull(emissive_particle_renderer))
		QDEL_NULL(emissive_particle_renderer)
	force_redraw()

/**
 * tl;dr
 *
 * we don't track the 'real' top level atom in beam
 * so this causes problems since component signal registrations are idempotent for a given (target, listening, signal) tuple
 * we don't want that but that's what makes comsigs efficient
 *
 * so this is here because this means /datum/beam isn't the only datum when source / target are part of the same
 * nested contents tree, avoiding collisions from it
 */
/datum/beam_listener
	/// our beam
	var/datum/beam/beam
	/// our target
	var/atom/target

/datum/beam_listener/New(datum/beam/beam, atom/target)
	src.beam = beam
	src.target = target
	register()

/datum/beam_listener/Destroy()
	unregister()
	return ..()

/datum/beam_listener/proc/register()
	if(ismovable(target))
		var/atom/iterating = target
		do
			RegisterSignal(iterating, COMSIG_MOVABLE_MOVED, PROC_REF(on_move))
			iterating = iterating.loc
		while(ismovable(iterating))

/datum/beam_listener/proc/unregister()
	if(ismovable(target))
		var/atom/iterating = target
		do
			UnregisterSignal(iterating, COMSIG_MOVABLE_MOVED)
			iterating = iterating.loc
		while(ismovable(iterating))

/datum/beam_listener/proc/on_move(atom/movable/source, atom/old_loc, dir, forced, list/old_locs, momentum_change)
	beam.signal_redraw(arglist(args))

//* Segmented Renderers *//

/atom/movable/render/beam_segments
	SET_APPEARANCE_FLAGS(PIXEL_SCALE | KEEP_TOGETHER)
	animate_movement = NONE

	/// segments in us
	var/list/image/segment_appearances = list()

/atom/movable/render/beam_segments/emissive
	plane = EMISSIVE_PLANE

/atom/movable/render/beam_segments/emissive/Initialize(mapload)
	ASSERT(istype(loc, /atom/movable/render/beam_segments))
	loc:vis_contents += src
	return ..()

/atom/movable/render/beam_segments/emissive/Destroy()
	ASSERT(istype(loc, /atom/movable/render/beam_segments))
	loc:vis_contents -= src
	return ..()

//* Colliders *//

INITIALIZE_IMMEDIATE(/atom/movable/beam_collider)
/atom/movable/beam_collider
	atom_flags = ATOM_ABSTRACT
	animate_movement = NONE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = INVISIBILITY_ABSTRACT

	/// parent beam
	var/datum/beam/parent

/atom/movable/beam_collider/Initialize(mapload, datum/beam/parent)
	SHOULD_CALL_PARENT(FALSE)
	src.parent = parent
	atom_flags |= ATOM_INITIALIZED
	return INITIALIZE_HINT_NORMAL

/atom/movable/beam_collider/Destroy()
	if(!isnull(parent))
		// make sure we uncross everything!
		move_onto(null)
		parent = null
	return ..()

/atom/movable/beam_collider/proc/move_onto(turf/where)
	if(where == loc)
		return
	for(var/atom/movable/other as anything in loc)
		if(other == src)
			continue
		if(other.atom_flags & ATOM_ABSTRACT)
			continue
		parent.uncrossed(other)
	parent.uncrossed(loc)
	abstract_move(where)
	parent.crossed(loc)
	for(var/atom/movable/other as anything in loc)
		if(other == src)
			continue
		if(other.atom_flags & ATOM_ABSTRACT)
			continue
		parent.crossed(other)

/atom/movable/beam_collider/Crossed(atom/movable/AM)
	. = ..()
	if(AM.atom_flags & (ATOM_ABSTRACT))
		return
	parent.crossed(AM)

/atom/movable/beam_collider/Uncrossed(atom/movable/AM)
	. = ..()
	if(AM.atom_flags & (ATOM_ABSTRACT))
		return
	parent.uncrossed(AM)

/atom/movable/beam_collider/Move()
	return FALSE

/atom/movable/beam_collider/doMove(atom/destination)
	if(destination == null)
		return ..()
	return FALSE

//* Stretched Renderers *//

/atom/movable/render/beam_line
	appearance_flags = KEEP_TOGETHER
	animate_movement = NONE

/atom/movable/render/beam_line/emissive
	plane = EMISSIVE_PLANE

/atom/movable/render/beam_line/emissive/Initialize(mapload)
	ASSERT(istype(loc, /atom/movable/render/beam_line))
	loc:vis_contents += src
	return ..()

/atom/movable/render/beam_line/emissive/Destroy()
	ASSERT(istype(loc, /atom/movable/render/beam_line))
	loc:vis_contents -= src
	return ..()

//* Particle Renderers *//

/atom/movable/render/particle/beam_line
	appearance_flags = KEEP_TOGETHER
	animate_movement = NONE

/atom/movable/render/particle/beam_line/emissive
	plane = EMISSIVE_PLANE

/atom/movable/render/particle/beam_line/emissive/Initialize(mapload)
	ASSERT(istype(loc, /atom/movable/render/particle/beam_line))
	loc:vis_contents += src
	return ..()

/atom/movable/render/particle/beam_line/emissive/Destroy()
	ASSERT(istype(loc, /atom/movable/render/particle/beam_line))
	loc:vis_contents -= src
	return ..()
