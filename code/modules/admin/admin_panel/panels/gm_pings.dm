//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY_TYPED(gm_pings, /datum/gm_ping)

/**
 * Contextual GM ping system.
 */
/datum/gm_ping
	/// unique id, lazy
	/// * not for persistent purposes, that comes later
	/// * not guaranteed to be unique, just used to filter/resolve with ref()
	var/lazy_unsafe_uid
	var/static/lazy_unsafe_uid_next = 0

	/// originating ckey
	var/originating_ckey

	/// originating mob weakref, if any
	var/datum/weakref/originating_mob_weakref
	/// cached tgui data for originating mob if it's deleted, if any
	var/list/originating_mob_ui_data_snapshot

	/// original message. NOT SANITIZED. treat as saycode pre-parse.
	var/unsanitized_message

	/// linked component. if it exists, we have in-world-context using it.
	var/datum/component/gm_ping/context_component
	/// linked component ui data snapshot if it's deleted, if any
	var/list/context_component_ui_data_snapshot

/datum/gm_ping/New()
	++lazy_unsafe_uid_next
	if(lazy_unsafe_uid_next >= SHORT_REAL_LIMIT)
		lazy_unsafe_uid_next = -(SHORT_REAL_LIMIT - 1)
	lazy_unsafe_uid = num2text(lazy_unsafe_uid_next, 999)

/datum/gm_ping/Destroy()
	originating_mob_weakref = null
	QDEL_NULL(context_component)
	return ..()

/datum/gm_ping/proc/link_context(atom/target)
	#warn impl

/datum/gm_ping/proc/ui_panel_data()
	return list(
	)

/datum/gm_ping/proc/ui_panel_static_data()
	return list(
		"ref" = ref(src),
		"lazyUid" = lazy_unsafe_uid,
		"playerCkey" = originating_ckey,
		// DO NOT REMOVE THE FUCKING HTML ENCODE OR YOU WILL XSS THE ADMINS!!!
		"messageAsHtml" = say_emphasis(html_encode(unsanitized_message)),
	)

/datum/gm_ping/proc/encode_ui_panel_origination_data()
	#warn impl

/datum/gm_ping/proc/pull_ui_panel_mob_data()
	var/mob/resolved = originating_mob_weakref?.resolve()
	if(resolved)
		var/list/encoded = encode_ui_panel_origination_data()
		originating_mob_ui_data_snapshot = encoded
		return list(
			"deleted" = FALSE,
			"data" = encoded,
		)
	else
		return list(
			"deleted" = TRUE,
			"data" = originating_mob_ui_data_snapshot,
		)

/datum/gm_ping/proc/encode_ui_panel_context_data()
	#warn impl

/datum/gm_ping/proc/pull_ui_panel_context_data()
	if(QDELETED(context_component))
		return list(
			"deleted" = TRUE,
			"data" = context_component_ui_data_snapshot,
		)
	else
		var/list/encoded = encode_ui_panel_context_data()
		context_component_ui_data_snapshot = encoded
		return list(
			"deleted" = FALSE,
			"data" = encoded,
		)

/**
 * Projects a context tag up to the world for admins to see.
 */
/datum/component/gm_ping
	/// owning datum
	var/datum/gm_ping/owner
	#warn impl

/atom/movable/render/gm_ping
	#warn impl



/datum/admin_panel/gm_pings
	name = "GM Pings"

/datum/admin_panel/gm_pings/ui_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_panel/gm_pings/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_panel/gm_pings/ui_nested_data(mob/user, datum/tgui/ui)
	. = ..()

/datum/admin_panel/gm_pings/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()



#warn impl
