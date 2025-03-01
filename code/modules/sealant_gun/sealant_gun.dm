//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/firemode/sealant_gun
	cycle_cooldown = 0.4 SECONDS

/obj/item/gun/projectile/sealant_gun
	name = "sealant gun"
	desc = "A space-age damage control tool. Uses pressurized sealant canisters to shoot \
	globules full of metallic foam."
	icon = 'icons/items/misc/sealant_gun.dmi'
	icon_state = "gun"

	firemodes = list(
		/datum/firemode/sealant_gun
	)

	render_wielded = TRUE

	var/obj/item/sealant_tank/tank
	var/tank_insert_sound
	var/tank_remove_sound
	var/tank_insert_delay = 0
	var/tank_remove_delay = 0

/obj/item/gun/projectile/sealant_gun/Destroy()
	QDEL_NULL(tank)
	return ..()

/obj/item/gun/projectile/sealant_gun/consume_next_projectile(datum/gun_firing_cycle/cycle)
	. = ..()




#warn impl

/obj/item/gun/projectile/sealant_gun/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()

/obj/item/gun/projectile/sealant_gun/on_attack_hand(datum/event_args/actor/clickchain/e_args)
	. = ..()

/obj/item/gun/projectile/sealant_gun/context_act(datum/event_args/actor/e_args, key)
	. = ..()

/obj/item/gun/projectile/sealant_gun/context_query(datum/event_args/actor/e_args)
	. = ..()

/obj/item/gun/projectile/sealant_gun/proc/user_clickchain_load_tank(obj/item/sealant_tank/tank, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)

/obj/item/gun/projectile/sealant_gun/proc/user_clickchain_unload_tank(datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, no_sound, no_message)

/obj/item/gun/projectile/sealant_gun/proc/load_tank(obj/item/sealant_tank/tank, silent)

/obj/item/gun/projectile/sealant_gun/proc/unload_tank(atom/new_loc, silent) as /obj/item/sealant_tank
	RETURN_TYPE(/obj/item/sealant_tank)
