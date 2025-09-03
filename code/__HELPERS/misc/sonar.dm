/**
 * file for sonar functions
 *
 * sonar basically functions as a filter over everything that renders in a way people can see.
 */

/**
 * gets an abstract sonar appearance
 */
/datum/controller/subsystem/sonar/proc/get_shape_raw(type, color = "#ffffff")
	RETURN_TYPE(/image)
	var/image/rendering = new
	rendering.icon = 'icons/screen/rendering/vfx/sonar.dmi'
	rendering.color = color
	rendering.alpha = 127
	rendering.plane = FLOAT_PLANE
	rendering.layer = FLOAT_LAYER
	rendering.appearance_flags = RESET_TRANSFORM | RESET_COLOR
	switch(type)
		if(SONAR_IMAGE_CIRCLE)
			rendering.icon_state = "circle"
		if(SONAR_IMAGE_HEXAGON)
			rendering.icon_state = "hexagon"
		if(SONAR_IMAGE_SQUARE)
			rendering.icon_state = "square"
		if(SONAR_IMAGE_TRIANGLE)
			rendering.icon_state = "triangle"
		// SONAR_IMAGE_STATIC is not implemented.
	return rendering

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
	addtimer(CALLBACK(src, PROC_REF(remove_sonar_images), images, clients, fadeout), sustain, TIMER_CLIENT_TIME)

/datum/controller/subsystem/sonar/proc/remove_sonar_images(list/image/images, list/client/clients, time)
	for(var/image/I as anything in images)
		animate(I, alpha = 0, time = time, easing = SINE_EASING)
	addtimer(CALLBACK(src, PROC_REF(dispose_sonar_images), images, clients), time, TIMER_CLIENT_TIME)

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

/**
 * make a *centered* sonar image.
 */
/atom/proc/make_sonar_image(resolution)

/atom/movable/make_sonar_image(resolution)
	if(resolution == SONAR_RESOLUTION_NONE)
		return
	if(invisibility)
		return
	var/image/rendering
	switch(resolution)
		if(SONAR_RESOLUTION_VISIBLE)
			if(ismob(src))
				rendering = vfx_clone_as_outline(127, 1, 0, 0)
			else
				rendering = vfx_clone_as_outline(127)
		if(SONAR_RESOLUTION_WALLHACK)
			rendering = vfx_clone_as_greyscale()
		if(SONAR_RESOLUTION_BLOCKY)
			rendering = make_sonar_shape()
	if(isnull(rendering))
		return
	rendering.pixel_x = pixel_x - (icon_x_dimension == WORLD_ICON_SIZE)? 0 : ((icon_x_dimension - WORLD_ICON_SIZE) / 2) + step_x
	rendering.pixel_y = pixel_y - (icon_y_dimension == WORLD_ICON_SIZE)? 0 : ((icon_y_dimension - WORLD_ICON_SIZE) / 2) + step_y
	. = rendering

/atom/proc/make_sonar_shape()
	return

/turf/make_sonar_image(resolution)
	if(!density)
		return
	if(invisibility || !x)		// doing !x is turf or on turf check
		return
	var/image/rendering
	switch(resolution)
		if(SONAR_RESOLUTION_VISIBLE)
			rendering = vfx_clone_as_outline(127)
		if(SONAR_RESOLUTION_WALLHACK)
			rendering = vfx_clone_as_greyscale()
		if(SONAR_RESOLUTION_BLOCKY)
			rendering = make_sonar_shape()
	if(isnull(rendering))
		return
	. = rendering

/turf/make_sonar_shape()
	if(!density)
		return
	return SSsonar.get_shape_raw(SONAR_IMAGE_SQUARE)

/mob/make_sonar_shape()
	var/image/rendering = SSsonar.get_shape_raw(SONAR_IMAGE_SQUARE)
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
	rendering.transform = transform_matrix_construct(scale, 0, 0, scale, 0, 0)
	rendering.pixel_x = rendering.pixel_y = round(WORLD_ICON_SIZE * (1 - scale) * 0.5, 1)
	return rendering

/obj/vehicle/sealed/mecha/make_sonar_shape()
	return SSsonar.get_shape_raw(SONAR_IMAGE_HEXAGON)

/obj/make_sonar_shape()
	if(!density)
		return
	var/image/rendering = SSsonar.get_shape_raw(SONAR_IMAGE_SQUARE)
	rendering.transform = transform_matrix_construct(0.5, 0, 0, 0.5, 0, 0)
	rendering.pixel_x = rendering.pixel_y = 8
	return rendering

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

/atom/movable/lighting_overlay/make_sonar_image(resolution)
	return
