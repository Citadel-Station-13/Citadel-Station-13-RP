//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * The screen objects for actor HUDs
 */
/atom/movable/screen/actor_hud

	/// our owning actor hud
	var/datum/actor_hud/inventory/hud

/atom/movable/screen/actor_hud/Initialize(mapload, datum/actor_hud/inventory/hud)
	. = ..()
	src.hud = hud
	// todo: cache this and don't keep grabbing it?
	sync_to_preferences(hud.holder.owner?.legacy_get_hud_preferences() || GLOB.default_hud_preferences)

/atom/movable/screen/actor_hud/Destroy()
	hud = null
	return ..()

/atom/movable/screen/actor_hud/check_allowed(mob/user)
	return ..() && hud.actor == user
