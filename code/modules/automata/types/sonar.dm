// todo: /datum/automata/sonar this instead of /wave.

/datum/automata/wave/sonar
	wave_spread = WAVE_SPREAD_MINIMAL
	/// global resolution
	var/resolution = SONAR_RESOLUTION_VISIBLE
	/// renderer anchor
	var/turf/rendering_anchor
	/// this tick's renderer
	var/atom/movable/rendering
	/// cached rendering anchor x
	var/anchoring_x
	/// cached rendering anchor y
	var/anchoring_y
	/// this tick's collected overlays
	var/list/rendering_overlays

/datum/automata/wave/sonar/setup_auto(turf/T, power, dir)
	. = ..()
	rendering_anchor = T
	anchoring_x = T.x
	anchoring_y = T.y

/datum/automata/wave/sonar/tick()
	rendering = __vfx_see_anywhere_atom_holder_at(rendering_anchor)
	rendering.plane = SONAR_PLANE
	rendering_overlays = list()
	. = ..()
	if(QDELETED(src)) // deleted during tick
		return
	flick_renderer(rendering)
	rendering_overlays = null
	rendering = null

/datum/automata/wave/sonar/act(turf/T, dirs, power)
	. = power - 1
	if(isspaceturf(T))
		return 0	// nah
	flick_sonar(T)
	for(var/obj/O in T)
		flick_sonar(O)
	for(var/mob/M in T)
		flick_sonar(M)

/datum/automata/wave/sonar/act_cross(atom/movable/AM, power)
	flick_sonar(AM)

/datum/automata/wave/sonar/cleanup()
	QDEL_NULL(rendering)
	rendering_anchor = null
	anchoring_x = null
	anchoring_y = null
	return ..()

/datum/automata/wave/sonar/proc/flick_sonar(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(!isnull(M.client) && !TIMER_COOLDOWN_CHECK(M, CD_INDEX_SONAR_NOISE))
			to_chat(M, SPAN_WARNING("You hear a quiet click."))
			TIMER_COOLDOWN_START(M, CD_INDEX_SONAR_NOISE, 7.5 SECONDS)
		// todo: M.provoke() for AI...
	var/image/overlay = AM.make_sonar_image(resolution)
	if(isnull(overlay))
		return
	// shift, and also add the see anywhere pixel shift to anchor it
	overlay.pixel_x += (AM.x - anchoring_x) * WORLD_ICON_SIZE + VFX_SEE_ANYWHERE_PIXEL_SHIFT
	overlay.pixel_y += (AM.y - anchoring_y) * WORLD_ICON_SIZE + VFX_SEE_ANYWHERE_PIXEL_SHIFT
	overlay.layer = MANGLE_PLANE_AND_LAYER(AM.plane, AM.layer)
	rendering_overlays += overlay

/datum/automata/wave/sonar/proc/flick_renderer(atom/movable/renderer)
	if(isnull(renderer))
		return
	renderer.overlays += rendering_overlays
	animate(renderer, alpha = 255, time = 0.1 SECONDS)
	animate(alpha = 0, time = 1 SECONDS)
	// end
	QDEL_IN(renderer, 1.1 SECONDS)

/datum/automata/wave/sonar/single_mob
	var/mob/receiver

/datum/automata/wave/sonar/single_mob/Destroy()
	receiver = null
	return ..()

// /datum/automata/wave/sonar/single_mob/flick_images(list/atom/movable/holders)
// 	if(!receiver.client)
// 		return
// 	SSsonar.flick_sonar_image(images, list(receiver.client))
