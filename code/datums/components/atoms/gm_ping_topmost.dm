//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/component/gm_ping_topmost
	registered_type = /datum/component/gm_ping_topmost
	/// components part of us
	var/list/datum/component/gm_ping/pings = list()
	/// renderer
	var/atom/movable/render/gm_ping_topmost/renderer

/datum/component/gm_ping_topmost/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/gm_ping_topmost/Destroy()
	qdel(renderer)
	return ..()

/datum/component/gm_ping_topmost/proc/add_ping(datum/component/gm_ping/ping)
	pings += ping

/datum/component/gm_ping_topmost/proc/remove_ping(datum/component/gm_ping/ping)
	pings -= ping
	if(!length(pings))
		qdel(src)

/datum/component/gm_ping_topmost/proc/update_render()
	if(!renderer)
		renderer = new(parent)
	renderer.update()
