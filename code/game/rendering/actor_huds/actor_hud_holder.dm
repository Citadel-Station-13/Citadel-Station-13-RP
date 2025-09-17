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
	var/datum/actor_hud/inventory/inventory

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

/**
 * syncs hud preferences
 */
/datum/actor_hud_holder/proc/sync_all_to_preferences(datum/hud_preferences/preference_set)
	inventory?.sync_to_preferences(preference_set)

/**
 * get all screens
 */
/datum/actor_hud_holder/proc/screens()
	. = list()
	for(var/datum/actor_hud/hud as anything in all_huds())
		. += hud.screens()

/**
 * get all screens
 */
/datum/actor_hud_holder/proc/images()
	. = list()
	for(var/datum/actor_hud/hud as anything in all_huds())
		. += hud.images()

/**
 * get all huds
 */
/datum/actor_hud_holder/proc/all_huds()
	return list(
		inventory,
	)

/**
 * apply everything to our client
 */
/datum/actor_hud_holder/proc/reassert_onto_owner()
	owner.images |= images()
	owner.screen |= screens()
