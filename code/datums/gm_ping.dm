//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY_TYPED(gm_pings, /datum/gm_ping)
GLOBAL_VAR_INIT(gm_ping_ghost_allowed, FALSE)

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
	/// originating key because it's prettier than ckey
	var/originating_key

	/// where was the ping made?
	var/turf/created_at

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
	GLOB.gm_pings -= src
	QDEL_NULL(context_component)
	return ..()

/datum/gm_ping/proc/chat_output()
	var/rendered = say_emphasis(html_encode(unsanitized_message))
	return "[lazy_unsafe_uid] @ [context_component?.parent] - From '[originating_ckey]', a '[SPAN_TOOLTIP(rendered, "[length_char(unsanitized_message)] character message")]'"

/datum/gm_ping/proc/link_context(atom/target)
	if(context_component)
		QDEL_NULL(context_component)
	if(target)
		context_component = target.AddComponent(/datum/component/gm_ping, src)
		if(QDELETED(context_component))
			context_component = null

// for stuff that may change; refreshing will pull an update
/datum/gm_ping/proc/ui_panel_data()
	return list(
		"pingOrigination" = pull_ui_panel_mob_data(),
		"pingContext" = pull_ui_panel_context_data(),
	)

// for stuff that never changes; even refreshing won't change it
/datum/gm_ping/proc/ui_panel_static_data()
	return list(
		"ref" = ref(src),
		"lazyUid" = lazy_unsafe_uid,
		"playerCkey" = originating_ckey,
		"playerKey" = originating_key,
		// DO NOT REMOVE THE FUCKING HTML ENCODE OR YOU WILL XSS THE ADMINS!!!
		"messageAsHtml" = say_emphasis(html_encode(unsanitized_message)),
		"pingLocation" = encode_ui_panel_location_data(),
	)

/datum/gm_ping/proc/encode_ui_location(atom/target)
	. = list()
	var/turf/l_turf = get_turf(target)
	if(l_turf)
		.["coords"] = list(
			"name" = l_turf.name,
			"x" = l_turf.x,
			"y" = l_turf.y,
			"z" = l_turf.z,
		)
	else
		.["coords"] = null
	if(l_turf)
		var/datum/map/l_map = SSmapping.ordered_levels[l_turf.z]?.parent_map
		if(l_map)
			.["sector"] = list(
				"id" = l_map.id,
				"name" = l_map.name,
			)
		else
			.["sector"] = null
		var/obj/overmap/entity/l_overmap = get_overmap_sector(l_turf)
		if(l_overmap)
			.["overmap"] = list(
				"entity" = l_overmap.name,
				"x" = l_overmap.get_tile_x_f(),
				"y" = l_overmap.get_tile_y_f(),
				"map" = l_overmap.overmap?.name,
			)
		else
			.["overmap"] = null
	else
		.["sector"] = null
		.["overmap"] = null

/datum/gm_ping/proc/encode_ui_panel_location_data()
	return list(
		"name" = created_at.name,
		"location" = encode_ui_location(created_at),
	)

/datum/gm_ping/proc/encode_ui_panel_mob_data(mob/target)
	return list(
		"name" = target.real_name,
		"visibleName" = target.name,
		"location" = encode_ui_location(target)
	)

/datum/gm_ping/proc/pull_ui_panel_mob_data()
	var/mob/resolved = originating_mob_weakref?.resolve()
	if(resolved)
		var/list/encoded = encode_ui_panel_mob_data(resolved)
		originating_mob_ui_data_snapshot = encoded
		return list(
			"deleted" = FALSE,
			"data" = encoded,
		)
	else if(originating_mob_ui_data_snapshot)
		return list(
			"deleted" = TRUE,
			"data" = originating_mob_ui_data_snapshot,
		)
	else
		// if we never got a snapshot for some reason treat it as gone
		return null

/datum/gm_ping/proc/encode_ui_panel_context_data(datum/component/gm_ping/target)
	return list(
		// bite me it's an /atom component
		"name" = target.parent:name,
		"location" = encode_ui_location(target.parent),
		"ref" = REF(target.parent),
	)

/datum/gm_ping/proc/pull_ui_panel_context_data()
	if(QDELETED(context_component))
		if(context_component_ui_data_snapshot)
			return list(
				"deleted" = TRUE,
				"data" = context_component_ui_data_snapshot,
			)
		// if we never got a snapshot for some reason treat it as gone
		else
			return null
	else
		var/list/encoded = encode_ui_panel_context_data(context_component)
		context_component_ui_data_snapshot = encoded
		return list(
			"deleted" = FALSE,
			"data" = encoded,
		)
