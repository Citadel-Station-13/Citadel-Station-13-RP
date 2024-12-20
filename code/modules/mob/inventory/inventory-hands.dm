//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/inventory/proc/set_hand_count(count)
	LAZYINITLIST(held_items)
	held_items.len = count
	for(var/datum/actor_hud/inventory/hud in huds_using)
		hud.rebuild()
	//! legacy
	owner.swap_hand(count ? clamp(owner.active_hand, 1, count) : null)
	//! end
	SEND_SIGNAL(src, COMSIG_INVENTORY_SLOT_REBUILD)

/datum/inventory/proc/get_hand_count()
	return length(held_items)
