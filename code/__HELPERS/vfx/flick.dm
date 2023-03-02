/// Removes an image from a client's `.images`. Useful as a callback.
/proc/remove_image_from_client(image/image, client/remove_from)
	remove_from?.images -= image

/proc/remove_images_from_clients(image/image_to_show, list/show_to)
	for(var/client/add_to in show_to)
		add_to.images -= image_to_show

/// Flicks a certain overlay onto an atom, handling icon_state strings
/proc/flick_overlay(image/image_to_show, list/show_to, duration)
	if(!show_to || !length(show_to) || !image_to_show)
		return
	for(var/client/add_to in show_to)
		add_to.images += image_to_show
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_images_from_clients), image_to_show, show_to), duration, TIMER_CLIENT_TIME)

/// Flicks an overlay to anyone who can view this atom.
/proc/flick_overlay_view(image_to_show, duration)
	var/list/viewing = list()
	for(var/mob/viewer as anything in viewers(src))
		if(viewer.client)
			viewing += viewer.client
	flick_overlay(image_to_show, viewing, duration)
