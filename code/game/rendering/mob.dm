//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

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
		client.actor_huds.reassert_onto_owner()
		client.action_drawer.reassert_screen()
		INVOKE_ASYNC(client, TYPE_PROC_REF(/client, init_viewport_blocking))
		client.holder?.register_admin_planes(client)
	reload_fullscreen()
	hud_used?.reorganize_alerts()

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

/**
 * updates rendering on hud style or other appearance change
 */
/mob/proc/resync_rendering()
	if(!client)
		return
	client.actor_huds.sync_all_to_preferences(client.legacy_get_hud_preferences())
