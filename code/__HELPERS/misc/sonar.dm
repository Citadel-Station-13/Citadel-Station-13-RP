/**
 * file for sonar functions
 *
 * sonar basically functions as a filter over everything that renders in a way people can see.
 */

/**
 * gets an abstract sonar appearance
 */
/datum/controller/subsystem/sonar/proc/get_shape_raw(type, color = "#ffffff")
	RETURN_TYPE(/mutable_appearance)
	var/mutable_appearance/MA = new
	MA.icon = 'icons/screen/rendering/vfx/sonar.dmi'
	MA.color = color
	MA.alpha = 127
	MA.plane = FLOAT_PLANE
	MA.layer = FLOAT_LAYER
	MA.appearance_flags = RESET_TRANSFORM | RESET_COLOR
	switch(type)
		if(SONAR_IMAGE_CIRCLE)
			MA.icon_state = "circle"
		if(SONAR_IMAGE_HEXAGON)
			MA.icon_state = "hexagon"
		if(SONAR_IMAGE_SQUARE)
			MA.icon_state = "square"
		if(SONAR_IMAGE_TRIANGLE)
			MA.icon_state = "triangle"
		// SONAR_IMAGE_STATIC is not implemented.

// we don't use images because TILE_BOUND is awful
// therefore we'll just use a plane directly for performance
// instead of image on atom movable holder
// i fucking hate this engine

/**
 * flicks sonar image(s) to clients
 */
/*
/datum/controller/subsystem/sonar/proc/flick_sonar_image(list/image/images, list/client/clients, fadein = 0.1 SECONDS, sustain = 0.2 SECONDS, fadeout = 0.7 SECONDS)
	if(!islist(images))
		images = list(images)
	for(var/image/I as anything in images)
		I.alpha = 0
	// type filtered - clients are harddel'd
	for(var/client/C in clients)
		C.images += images
	for(var/image/I as anything in images)
		animate(I, alpha = 255, time = fadein, easing = SINE_EASING)
	addtimer(CALLBACK(src, .proc/remove_sonar_images, images, clients, fadeout), sustain, TIMER_CLIENT_TIME)

/datum/controller/subsystem/sonar/proc/remove_sonar_images(list/image/images, list/client/clients, time)
	for(var/image/I as anything in images)
		animate(I, alpha = 0, time = time, easing = SINE_EASING)
	addtimer(CALLBACK(src, .proc/dispose_sonar_images, images, clients), time, TIMER_CLIENT_TIME)

/datum/controller/subsystem/sonar/proc/dispose_sonar_images(list/image/images, list/client/clients)
	for(var/client/C in clients)
		C.images -= images
	for(var/image/I as anything in images)
		I.loc = null
*/

/atom/proc/__debug_to_sonar_appearance(resolution)
	appearance = make_sonar_image(resolution)

/*
/atom/proc/_debug_flick_sonar(resolution = SONAR_RESOLUTION_VISIBLE)
	var/atom/movable/holder = make_sonar_image(resolution)
	if(!I)
		return
	SSsonar.flick_sonar_image(list(I), GLOB.clients)
*/

/atom/proc/make_sonar_image(resolution)
	if(resolution == SONAR_RESOLUTION_NONE)
		return
	if(invisibility || !x)		// doing !x is turf or on turf check
		return
	var/atom/movable/holder = __vfx_see_anywhere_atom_holder_at(isturf(src)? src : loc)
	var/mutable_appearance/MA
	holder.plane = SONAR_PLANE
	holder.dir = dir
	holder.pixel_x += pixel_x
	holder.pixel_y += pixel_y
	// yea...
	holder.layer = plane * 100 + layer
	. = holder
	switch(resolution)
		if(SONAR_RESOLUTION_VISIBLE)
			MA = vfx_clone_as_outline(127)
			MA.pixel_x = MA.pixel_y = VFX_SEE_ANYWHERE_PIXEL_SHIFT
			holder.overlays += MA
		if(SONAR_RESOLUTION_WALLHACK)
			MA = vfx_clone_as_greyscale()
			MA.pixel_x = MA.pixel_y = VFX_SEE_ANYWHERE_PIXEL_SHIFT
			holder.overlays += MA
		if(SONAR_RESOLUTION_BLOCKY)
			MA = make_sonar_shape()
			MA.pixel_x = MA.pixel_y = VFX_SEE_ANYWHERE_PIXEL_SHIFT
			if(MA)
				holder.overlays += MA

/atom/proc/make_sonar_shape()
	return

/turf/make_sonar_shape()
	if(!density)
		return
	return SSsonar.get_shape_raw(SONAR_IMAGE_SQUARE)

/mob/make_sonar_shape()
	var/mutable_appearance/MA = SSsonar.get_shape_raw(SONAR_IMAGE_SQUARE)
	var/scale = 1
	switch(mob_size)
		if(MOB_TINY)
			scale = 0.4
		if(MOB_MEDIUM)
			scale = 0.7
		if(MOB_LARGE)
			scale = 1
		if(MOB_MINISCULE)
			scale = 0.2
		if(MOB_HUGE)
			scale = 1.5
	MA.transform = transform_matrix_construct(scale, 0, 0, scale, 0, 0)
	MA.pixel_x = MA.pixel_y = round(WORLD_ICON_SIZE * (1 - scale) * 0.5, 1)
	return MA

/obj/mecha/make_sonar_shape()
	return SSsonar.get_shape_raw(SONAR_IMAGE_HEXAGON)

/obj/make_sonar_shape()
	if(!density)
		return
	var/mutable_appearance/MA = SSsonar.get_shape_raw(SONAR_IMAGE_SQUARE)
	MA.transform = transform_matrix_construct(0.5, 0, 0, 0.5, 0, 0)
	MA.pixel_x = MA.pixel_y = 8
	return MA

// blacklist dumb things
/obj/structure/catwalk/make_sonar_image(resolution)
	return

/obj/structure/grille/make_sonar_image(resolution)
	return

/obj/structure/lattice/make_sonar_image(resolution)
	return

/obj/machinery/atmospherics/make_sonar_image(resolution)
	return

/obj/effect/make_sonar_image(resolution)
	return

/obj/structure/cable/make_sonar_image(resolution)
	return

/atom/movable/lighting_object/make_sonar_image(resolution)
	return
