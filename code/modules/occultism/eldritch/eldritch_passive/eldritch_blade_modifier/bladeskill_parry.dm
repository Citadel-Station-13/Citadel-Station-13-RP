//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Greatly enhances parrying done with heretic weapons.
 */
/datum/prototype/eldritch_passive/eldritch_blade_modifier/bladeskill_parry
	id = "bladeskill-parry"

// TODO: impl

/datum/prototype/eldritch_passive/eldritch_blade_modifier/bladeskill_cleave/on_blade_melee_impact(datum/eldritch_holder/source, mob/wielder, obj/item/eldritch_blade/blade, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()


#warn impl

/datum/prototype/eldritch_passive/eldritch_blade_modifier/bladeskill_parry/rust_spread
	id = "bladeskill-parry-rust"
