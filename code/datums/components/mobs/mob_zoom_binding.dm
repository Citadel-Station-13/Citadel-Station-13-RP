//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A binding to allow shifting around one's self perspective.
 *
 * The purpose of this is to allow a 'lock' system so that using a different scope
 * will automatically de-zoom the currently active one, if any.
 */
/datum/component/mob_zoom_binding
	registered_type = /datum/component/mob_zoom_binding
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	var/datum/callback/on_start
	var/datum/callback/on_stop

/datum/component/mob_zoom_binding/Initialize(datum/callback/on_strt, datum/callback/on_stop)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.on_start = on_start
	src.on_stop = on_stop

/datum/component/mob_zoom_binding/RegisterWithParent()
	on_start?.invoke_no_sleep()

/datum/component/mob_zoom_binding/UnregisterFromParent()
	on_stop?.invoke_no_sleep()

/**
 * Automatically applies freezoom to the mob's client.
 */
/datum/component/mob_zoom_binding/freezoom
	var/range_in_tiles

/datum/component/mob_zoom_binding/freezoom/Initialize(datum/callback/on_stop, range_in_tiles = 7)
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.range_in_tiles = range_in_tiles

/datum/component/mob_zoom_binding/freezoom/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(on_login))
	RegisterSignal(parent, COMSIG_MOB_CLIENT_PRE_LOGOUT, PROC_REF(on_logout))
	var/mob/m_parent = parent
	if(m_parent.client)
		on_login(m_parent, m_parent.client)

/datum/component/mob_zoom_binding/freezoom/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_MOB_CLIENT_LOGIN,
		COMSIG_MOB_CLIENT_LOGOUT,
	))
	var/mob/m_parent = parent
	if(m_parent.client)
		on_logout(m_parent, m_parent.client)

/datum/component/mob_zoom_binding/freezoom/proc/on_logout(mob/source, client/cli)
	cli?.DelComponent(/datum/component/client_freezoom_handler)

/datum/component/mob_zoom_binding/freezoom/proc/on_login(mob/source, client/cli)
	cli?.AddComponent(/datum/component/client_freezoom_handler, range_in_tiles * WORLD_ICON_SIZE)
