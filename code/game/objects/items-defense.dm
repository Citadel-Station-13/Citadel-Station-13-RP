//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Armor *//

/**
 * Called during a mob armor call cycle
 */
/obj/item/proc/mob_armorcall(mob/defending, list/shieldcall_args, fake_attack)
	// use our own armor
	var/datum/armor/our_armor = fetch_armor()
	our_armor.handle_shieldcall(shieldcall_args, fake_attack)

//* Shieldcall *//

/obj/item/register_shieldcall(datum/shieldcall/delegate)
	. = ..()
	if(delegate.shields_in_inventory)
		get_worn_mob()?.register_shieldcall(delegate)

/obj/item/unregister_shieldcall(datum/shieldcall/delegate)
	. = ..()
	if(delegate.shields_in_inventory)
		get_worn_mob()?.unregister_shieldcall(delegate)
