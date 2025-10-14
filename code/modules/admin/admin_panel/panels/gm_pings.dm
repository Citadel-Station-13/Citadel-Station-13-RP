//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/admin_panel/gm_pings
	name = "GM Pings"
	tgui_interface = "AdminGMPings"

/datum/admin_panel/gm_pings/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["ghostAllowed"] = GLOB.gm_ping_ghost_allowed

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
			log_and_message_admins("purged all GM pings", usr)
			QDEL_LIST(GLOB.gm_pings)
			update_static_data()
			return TRUE
		if("delPing")
			if(!target_ping)
				return TRUE
			log_and_message_admins("deleted GM ping [target_ping.lazy_unsafe_uid]", usr)
			qdel(target_ping)
			push_ui_data(data = list("pingIds" = encode_ping_ids()))
			return TRUE
		if("toggleGhostAllowed")
			var/new_state = params["enabled"]
			if(new_state == GLOB.gm_ping_ghost_allowed)
				return TRUE
			log_and_message_admins("[new_state ? "enabled" : "disabled"] ghost GM pings.", usr)
			GLOB.gm_ping_ghost_allowed = new_state
			return TRUE
		if("jmpPingOrigin")
			if(!target_ping)
				return TRUE
			var/mob/resolved_mob = get_turf(target_ping.originating_mob_weakref?.resolve())
			if(!resolved_mob)
				to_chat(owner.owner, SPAN_BOLDANNOUNCE("Couldn't locate ping context originating mob. Was it deleted?"))
				return TRUE
			owner.teleport_as_ghost_to_loc(resolved_mob)
			return TRUE
		if("jmpPingContext")
			if(!target_ping)
				return TRUE
			var/turf/resolved_context = get_turf(target_ping.context_component?.parent)
			if(!resolved_context)
				to_chat(owner.owner, SPAN_BOLDANNOUNCE("Couldn't locate ping context component. Was it deleted?"))
				return TRUE
			owner.teleport_as_ghost_to_loc(resolved_context)
			return TRUE
		if("jmpPingLocation")
			if(!target_ping)
				return TRUE
			owner.teleport_as_ghost_to_loc(target_ping.created_at)
			return TRUE
		if("refreshPings")
			var/list/assembled_nested_data = list()
			for(var/datum/gm_ping/ping as anything in GLOB.gm_pings)
				assembled_nested_data[ping.lazy_unsafe_uid] = ping.ui_panel_static_data() + ping.ui_panel_data()
			push_ui_nested_data(updates = assembled_nested_data)
			push_ui_data(data = list("pingIds" = encode_ping_ids()))
			return TRUE
		if("refreshPing")
			if(!target_ping)
				return TRUE
			push_ui_nested_data(updates = list(
				(target_ping.lazy_unsafe_uid) = target_ping.ui_panel_data(),
			))
			return TRUE
