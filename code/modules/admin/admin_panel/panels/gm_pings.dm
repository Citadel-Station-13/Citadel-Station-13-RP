//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_panel/gm_pings
	name = "GM Pings"
	tgui_interface = "AdminGMPings"

/datum/admin_panel/gm_pings/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["pingIds"] = encode_ping_ids()

/datum/admin_panel/gm_pings/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()
	for(var/datum/gm_ping/ping as anything in GLOB.gm_pings)
		.[ping.lazy_unsafe_uid] = ping.ui_panel_data() + ping.ui_panel_static_data()

/datum/admin_panel/gm_pings/proc/encode_ping_ids()
	. = list()
	for(var/datum/gm_ping/ping as anything in GLOB.gm_pings)
		. += ping.lazy_unsafe_uid

/datum/admin_panel/gm_pings/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/pRef = params["ref"]
	var/pUid = params["uid"]
	var/datum/gm_ping/target_ping
	if(pRef)
		var/datum/gm_ping/maybe_ping = locate(pRef)
		if(istype(maybe_ping, /datum/gm_ping) && maybe_ping.lazy_unsafe_uid == pUid)
			target_ping = maybe_ping
		else
			// UI can automatically call refreshPing to update, so don't flood.
			if(action != "refreshPing")
				to_chat(usr, SPAN_WARNING("Couldn't locate ping '[pRef]-[pUid]'; the ping may have been deleted."))
			return TRUE
	switch(action)
		if("purgeAll")
			QDEL_LIST(GLOB.gm_pings)
			update_static_data()
			return TRUE
		// TODO: Purge by ckey/mob once we're higher pop and need it.
		// if("purgeCkey")
		// if("purgeMob")
		if("delPing")
			if(!target_ping)
				return TRUE
			qdel(target_ping)
			push_ui_data(list("pingIds" = encode_ping_ids()))
			return TRUE
		if("jmpPingOrigin")
			if(!target_ping)
				return TRUE
			#warn impl
		if("jmpPingContext")
			if(!target_ping)
				return TRUE
			#warn impl
		if("jmpPingLocation")
			if(!target_ping)
				return TRUE
			#warn impl
		if("refreshPings")
			if(!target_ping)
				return TRUE
			push_ui_data(data = list("pingIds" = encode_ping_ids()))
			return TRUE
		if("refreshPing")
			push_ui_nested_data(updates = list(
				(target_ping.lazy_unsafe_uid) = target_ping.ui_panel_data(),
			))
			return TRUE
