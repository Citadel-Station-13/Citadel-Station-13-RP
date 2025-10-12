//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/movable/render/gm_ping_topmost
	atom_flags = ATOM_NONWORLD | ATOM_ABSTRACT
	maptext_x = -16
	maptext_height = 16
	maptext_width = 16
	#warn sprite
	var/datum/component/gm_ping_topmost/owning_component

/atom/movable/render/gm_ping_topmost/Initialize(mapload)
	if(ismovable(loc))
		var/atom/movable/where_at = loc
		where_at.vis_contents += src
	atom_flags |= ATOM_INITIALIZED
	return INITIALIZE_HINT_NORMAL

/atom/movable/render/gm_ping_topmost/Destroy()
	if(ismovable(loc))
		var/atom/movable/where_at = loc
		where_at.vis_contents -= src
	owning_component.renderer = null
	return ..()

/atom/movable/render/gm_ping_topmost/proc/update()
	maptext = MAPTEXT_CENTER("[length(owning_component.uids)]")
