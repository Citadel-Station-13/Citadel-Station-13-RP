//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/movable/render/gm_ping_topmost
	atom_flags = ATOM_NONWORLD | ATOM_ABSTRACT
	plane = ADMIN_PLANE
	layer = ADMIN_LAYER_GM_PING
	maptext_y = 10
	maptext_height = 16
	maptext_width = 16
	mouse_opacity = MOUSE_OPACITY_ICON
	pixel_x = 8
	pixel_y = 36
	icon = 'icons/screen/admin/gm_ping.dmi'
	icon_state = "gm_ping"
	name = "GM Ping (Contextual)"
	desc = "There's an active GM ping on an object on or in this entity."
	var/datum/component/gm_ping_topmost/owning_component

/atom/movable/render/gm_ping_topmost/Initialize(mapload, datum/component/gm_ping_topmost/owning_component)
	if(ismovable(loc))
		var/atom/movable/where_at = loc
		where_at.vis_contents += src
	atom_flags |= ATOM_INITIALIZED
	src.owning_component = owning_component
	animate(src, pixel_y = 34, time = 1.6 SECONDS, flags = ANIMATION_CONTINUE, loop = -1, easing = SINE_EASING)
	animate(src, pixel_y = 38, time = 1.6 SECONDS, flags = ANIMATION_CONTINUE, loop = -1, easing = SINE_EASING)
	return INITIALIZE_HINT_NORMAL

/atom/movable/render/gm_ping_topmost/Destroy()
	if(ismovable(loc))
		var/atom/movable/where_at = loc
		where_at.vis_contents -= src
	owning_component.renderer = null
	return ..()

/atom/movable/render/gm_ping_topmost/proc/update()
	maptext = MAPTEXT_CENTER("[length(owning_component.pings)]")

/atom/movable/render/gm_ping_topmost/examine(mob/user, dist)
	. = ..()
	if(!user.client.holder)
		return
	. += "<hr><center><h3>Pings</h3></center><br>"
	for(var/datum/component/gm_ping/ping_comp as anything in owning_component.pings)
		. += "- [ping_comp.owner.chat_output()]<br>"
	. += "<hr>"

