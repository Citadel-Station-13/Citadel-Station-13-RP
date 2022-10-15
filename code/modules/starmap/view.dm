/**
 * a view component used to manage views
 */
/datum/starmap_view
	/// host starmap
	var/datum/starmap/map
	/// viewing mob
	var/mob/user
	/// ui host
	var/datum/host

/datum/starmap_view/New(datum/starmap/S)
	if(S)
		bind(S)

/datum/starmap_view/Destroy()
	release()
	return ..()

/datum/starmap_view/proc/bind(datum/starmap/S)
	if(map)
		release()
	map = S
	LAZYOR(map.views, src)

/datum/starmap_view/proc/release()
	if(!map)
		return
	LAZYREMOVE(map.views, src)

/datum/starmap_view/ui_host(mob/user)
	return host

/datum/starmap_view/ui_static_data(mob/user)
	return map.static_data(user)

/datum/starmap_view/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	return map.data(user, ui, state)

/datum/starmap_view/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	return map.act(action, params, ui, state)
