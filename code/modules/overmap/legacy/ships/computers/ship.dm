/**
 * While these computers can be placed anywhere, they will only function if placed on either a non-space, non-shuttle turf
 * with an /obj/overmap/entity/visitable/ship present elsewhere on that z level, or else placed in a shuttle area with an /obj/overmap/entity/visitable/ship
 * somewhere on that shuttle. Subtypes of these can be then used to perform ship overmap movement functions.
 */
/obj/machinery/computer/ship
	var/obj/overmap/entity/visitable/ship/linked
	/// Weakrefs to mobs in direct-view mode.
	var/list/viewers
	/// how much the view is increased by when the mob is in overmap mode.
	var/extra_view = 0
	/// Has been emagged, no access restrictions.
	var/hacked = 0

/// A late init operation called in SSshuttle, used to attach the thing to the right ship.
/obj/machinery/computer/ship/proc/attempt_hook_up(obj/overmap/entity/visitable/ship/sector)
	if(!istype(sector))
		return
	if(sector.check_ownership(src))
		linked = sector
		return TRUE

/obj/machinery/computer/ship/proc/sync_linked(var/user = null)
	var/obj/overmap/entity/visitable/ship/sector = get_overmap_sector(z)
	if(!sector)
		return
	. = attempt_hook_up_recursive(sector)
	if(. && linked && user)
		to_chat(user, SPAN_NOTICE("[src] reconnected to [linked]"))
		user << browse(null, "window=[src]") // Close reconnect dialog

/obj/machinery/computer/ship/proc/attempt_hook_up_recursive(obj/overmap/entity/visitable/ship/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/overmap/entity/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/obj/machinery/computer/ship/proc/display_reconnect_dialog(var/mob/user, var/flavor)
	var/datum/browser/popup = new (user, "[src]", "[src]")
	popup.set_content("<center><strong><font color = 'red'>Error</strong></font><br>Unable to connect to [flavor].<br><a href='?src=\ref[src];sync=1'>Reconnect</a></center>")
	popup.open()

/obj/machinery/computer/ship/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["sync"])
		if(sync_linked(usr))
			interface_interact(usr)
		return TRUE

// In computer_shims for now - we had to define it.
// /obj/machinery/computer/ship/interface_interact(var/mob/user)
// 	ui_interact(user)
// 	return TRUE

/obj/machinery/computer/ship/ui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	switch(action)
		if("sync")
			sync_linked(usr)
			return TRUE
		if("close")
			unlook(usr)
			usr.unset_machine()
			return TRUE
	return FALSE

// Management of mob view displacement. look to shift view to the ship on the overmap; unlook to shift back.

/obj/machinery/computer/ship/proc/look(mob/user)
	var/WR = WEAKREF(user)
	if(WR in viewers)
		return
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook))
	// TODO GLOB.stat_set_event.register(user, src, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook))
	LAZYDISTINCTADD(viewers, WR)
	if(linked)
		user.reset_perspective(linked)
	user.set_machine(src)
	if(isliving(user))
		var/mob/living/L = user
		L.looking_elsewhere = 1
		L.handle_vision()
	var/list/view_size = decode_view_size(world.view)
	user.client?.set_temporary_view(view_size[1] + extra_view, view_size[2] + extra_view)

/obj/machinery/computer/ship/proc/unlook(mob/user, vis_update)
	user.reset_perspective()
	user.client?.reset_temporary_view()
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook))
	if(isliving(user))
		var/mob/living/L = user
		L.looking_elsewhere = 0
		if(!vis_update)
			L.handle_vision()
	// TODO GLOB.stat_set_event.unregister(user, src, TYPE_PROC_REF(/obj/machinery/computer/ship, unlook))
	LAZYREMOVE(viewers, WEAKREF(user))

/obj/machinery/computer/ship/proc/viewing_overmap(mob/user)
	return (WEAKREF(user) in viewers)

/obj/machinery/computer/ship/ui_status(mob/user)
	. = ..()
	if(. > UI_DISABLED)
		if(viewing_overmap(user))
			look(user)
		return
	unlook(user)

/obj/machinery/computer/ship/ui_close(mob/user, datum/tgui_module/module)
	. = ..()
	user.unset_machine()
	unlook(user)

/obj/machinery/computer/ship/check_eye(mob/user, vis_update)
	if(!get_dist(user, src) > 1 || user.blinded || !linked)
		unlook(user, vis_update)
		return -1
	else
		return 0

/obj/machinery/computer/ship/sensors/Destroy()
	sensors = null
	if(LAZYLEN(viewers))
		for(var/datum/weakref/W in viewers)
			var/M = W.resolve()
			if(M)
				unlook(M)
	. = ..()

/obj/machinery/computer/ship/emag_act(remaining_charges, mob/user)
	if (!hacked)
		req_access = list()
		req_one_access = list()
		hacked = TRUE
		to_chat(user, "You short out the console's ID checking system. It's now available to everyone!")
		return TRUE
