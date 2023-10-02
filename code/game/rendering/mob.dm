// todo: rendering handling/init/destruction should be on mob and client
//       mob side should handle mob state
//       client side should handle apply/remove/switch.

/**
 * initializes screen rendering. call on mob new
 */
/mob/proc/init_rendering()

/**
 * loads screen rendering. call on mob login
 */
/mob/proc/reload_rendering()
	if(!isnull(client))
		if(isnull(client.parallax_holder))
			client.create_parallax()
		else
			client.parallax_holder.reset(force = TRUE)
		if(isnull(client.global_planes))
			client.global_planes = new
		client.global_planes.apply(client)
		client.update_clickcatcher()
		client.using_perspective?.reload(client, TRUE)
		INVOKE_ASYNC(client, TYPE_PROC_REF(/client, init_viewport_blocking))
	reload_fullscreen()

/**
 * reloads rendering after screen viewport size change
 */
/mob/proc/refit_rendering()
	if(!isnull(client))
		client?.parallax_holder?.reset(force = TRUE)
		client?.update_clickcatcher()
	reload_fullscreen()

/**
 * destroys screen rendering. call on mob del
 */
/mob/proc/dispose_rendering()
	wipe_fullscreens()
