/**
 * file for sonar functions
 *
 * sonar basically functions as a filter over everything that renders in a way people can see.
 */

/**
 * gets an abstract sonar appearance
 */
/datum/controller/subsystem/sonar/proc/get_shape_appearance(type, color)
	RETURN_TYPE(/mutable_appearance)
	. = new /mutable_appearance

	#warn impl

/**
 * gets a filter for a given resolution
 */
/datum/controller/subsystem/sonar/proc/get_sonar_filter(resolution)
	#warn impl

/**
 * gets an appearance from an input atom and a given resolution
 */
/datum/controller/subsystem/sonar/proc/get_sonar_appearance(atom/rendering, resolution)
	// this proc will be very messy
	#warn impl

/**
 * gets an image for a sonar appearance
 */
/datum/controller/subsystem/sonar/proc/get_sonar_image(mutable_appearance/MA, loc)
	var/image/I = new
	I.appearance = MA
	I.plane = SONAR_PLANE
	I.loc = loc
	return I

/**
 * flicks sonar image(s) to clients
 */
/datum/controller/subsystem/sonar/proc/flick_sonar_image(list/image/images, list/client/clients, time = 2 SECONDS, fadein, fadeout, easein, easeout)
	if(!islist(images))
		images = list(images)
	for(var/image/I as anything in images)
		I.alpha = 0
	// type filtered - clients are harddel'd
	for(var/client/C in clients)
		C.images += images
	for(var/image/I as anything in images)
		animate(I, alpha = 255, time = fadein || (time * 0.25), easing = easin || SINE_EASING)
	addtimer(CALLBACK(src, .proc/remove_sonar_images, images, clients, fadeout || (time * 0.75), easout || SINE_EASING), time - (fadeout || (time * 0.75)), TIMER_CLIENT_TIME)

/datum/controller/subsystem/sonar/proc/remove_sonar_images(list/image/images, list/client/clients, time, easing)
	for(var/image/I in images)
		animate(I, alpha = 0, time = time, easing = easing)
	addtimer(CALLBACK(src, .proc/dispose_sonar_images, images, clients), time, TIMER_CLIENT_TIME)

/datum/controller/subsystem/sonar/proc/dispose_sonar_images(list/image/images, list/client/clients)
	for(var/client/C in clients)
		C.images -= images
	for(var/image/I in images)
		qdel(I)

/atom/proc/__debug_to_sonar_appearance()
	appearance = get_sonar_appearance(src, resolution)

/atom/proc/_debug_flick_sonar_all(resolution, time, fadein, fadeout, easein, easeout)
	SSsonar.flick_sonar_image(SSsonar.get_sonar_image(SSsonar.get_sonar_appearance(src, resolution), get_turf(src), GLOB.clients, time, fadein, fadeout, easein, easeout))
