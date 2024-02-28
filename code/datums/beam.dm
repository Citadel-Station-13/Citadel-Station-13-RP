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
	#warn impl

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
	#warn impl

/**
 * creates a beam that renders via particles
 *
 * you must delete this beam yourself, unlike legacy beams
 *
 * @params
 * * source - where to draw from
 * * target - where to draw to
 * * collider_type - set to a type to create colliders
 * * particle_reference - particle reference to use.
 * * emissive_reference - emissive particle reference, if any
 */
/proc/create_particle_beam(atom/source, atom/target, collider_type, particles/particle_reference, particles/emissive_reference)
	#warn impl

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

	//* collision *//
	/// requires collision
	var/colliders = FALSE
	/// registered colliding entities, turf or movable; only made as a list if collision or segment mode is enabled
	var/list/atom/colliding

	//* segmentation *//
	/// 1 to n, beam segments; used both for colliders and for rendering if needed
	var/list/atom/movable/beam_element/elements

	//* graphics *//
	/// graphics mode
	var/beam_visual_mode
	/// if we are in stretch mode, this is our rendering line
	var/atom/movable/graphics_render/beam_render/line_renderer
	/// if we are in stretch mode, this is our emissive rendering line
	var/atom/movable/graphics_render/beam_render/emissive_line_renderer
	/// if we are in particle mode, this is our renderer
	var/atom/movable/particle_render/particle_renderer
	/// if we are in particle mode, this is our emissive renderer
	var/atom/movable/particle_render/emissive_particle_renderer
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

/datum/beam/proc/unregister()

/datum/beam/proc/initialize()

/datum/beam/proc/redraw()


/datum/beam/proc/perform_draw()

#warn impl all

/atom/movable/graphics_render/beam_element

	/// our emissive renderer
	var/atom/movable/graphics_render/beam_element_emissive/emissives

/atom/movable/graphics_render/beam_element_emissive

/atom/movable/graphics_render/beam_render
