//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * multitools used by practitioners, and decent weapons
 *
 * * try to keep effects data-driven as possible, but implementing effects on subtypes is allowed.
 * * try to keep things as stateless as possible. the weapon is thematically a focusing tool, not a standalone one.
 *
 * TODO: persistence serialization, entity prototype ID?
 */
/obj/item/eldritch_blade
	name = "crescent blade"
	desc = "A strange, crescent blade. Its shape feels off, somehow."
	#warn sprite

	damage_force = 22.75
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	damage_flag = ARMOR_MELEE
	damage_tier = 4.5
	damage_type = DAMAGE_TYPE_BRUTE

#warn impl

/obj/item/eldritch_blade/melee_impact(datum/event_args/actor/clickchain/clickchain, clickchain_flags, datum/melee_attack/weapon/attack_style)
	. = ..()


/obj/item/eldritch_blade/ash

/obj/item/eldritch_blade/blade

/obj/item/eldritch_blade/cosmic

/obj/item/eldritch_blade/flesh

/obj/item/eldritch_blade/lock

/obj/item/eldritch_blade/moon

/obj/item/eldritch_blade/rust

/obj/item/eldritch_blade/void
