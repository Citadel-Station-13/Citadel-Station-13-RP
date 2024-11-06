//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A holder for actor HUDs on a client.
 */
/datum/actor_hud_holder
	/// owning client
	var/client/owner

	/// inventory hud
	var/datum/actor_hud/inventory

/datum/actor_hud_holder/New(client/C)
	owner = C

	inventory = new(src)

/datum/actor_hud_holder/Destroy()
	QDEL_NULL(inventory)

	owner = null
	return ..()

/**
 * reset every hud to a mob
 */
/datum/actor_hud_holder/proc/rebind_all_to_mob(mob/target)
	#warn impl

#warn impl
