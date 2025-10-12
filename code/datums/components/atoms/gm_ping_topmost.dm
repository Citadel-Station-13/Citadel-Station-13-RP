//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/gm_ping_topmost
	/// uids part of us
	var/list/uids = list()
	/// renderer
	var/atom/movable/render/gm_ping_topmost/renderer

/datum/component/gm_ping/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(.))
		return COMPONENT_INCOMPATIBLE

/datum/component/gm_ping_topmost/Destroy()
	qdel(renderer)
	return ..()

/datum/component/gm_ping_topmost/proc/add_uid(uid)
	uids += uid

/datum/component/gm_ping_topmost/proc/remove_uid(uid)
	uids -= uid
	if(!length(uids))
		qdel(src)

/datum/component/gm_ping_topmost/proc/update_render()
	if(!renderer)
		renderer = new(parent)
	renderer.update()
