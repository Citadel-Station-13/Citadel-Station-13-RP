//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A holder for actor HUDs on a client.
 *
 * This is used for stuff like inventory.
 */
/datum/actor_hud_holder
	/// owning client
	var/client/owner

	/// inventory hud
	var/datum/actor_hud/inventory

/datum/actor_hud_holder/New(client/C)
	// set owner
	owner = C
	// create huds
	inventory = new(src)

/datum/actor_hud_holder/Destroy()
	// destroy huds
	QDEL_NULL(inventory)
	// teardown owner
	owner = null
	// do rest
	return ..()

/**
 * reset every hud to a mob
 */
/datum/actor_hud_holder/proc/bind_all_to_mob(mob/target)
	inventory.bind_to_mob(target)

#warn impl
