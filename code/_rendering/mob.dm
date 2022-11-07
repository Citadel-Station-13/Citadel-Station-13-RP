/**
 * initializes screen rendering. call on mob new
 */
/mob/proc/init_rendering()

/**
 * loads screen rendering. call on mob login
 */
/mob/proc/reload_rendering()
	if(!client.parallax_holder)
		client.CreateParallax()
	else
		client.parallax_holder.Reset(force = TRUE)

	reload_fullscreen()
	client.update_clickcatcher()
	INVOKE_ASYNC(client, /client/proc/init_viewport_blocking)

/**
 * reloads rendering after screen viewport size change
 */
/mob/proc/refit_rendering()
	client?.parallax_holder?.Reset(force = TRUE)
	reload_fullscreen()
	client?.update_clickcatcher()

/**
 * destroys screen rendering. call on mob del
 */
/mob/proc/dispose_rendering()
	wipe_fullscreens()
