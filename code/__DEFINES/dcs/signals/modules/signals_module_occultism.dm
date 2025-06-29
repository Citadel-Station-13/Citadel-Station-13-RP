//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* /datum/eldritch_holder *//

/// called on a holder when an eldritch projectile being prepared for firing: (mob/firer, obj/projectile/proj)
/// * check type of projectile to know what it is.
#define COMSIG_ELDRITCH_HOLDER_FIRE_PROJECTILE "eldritch-fire_projectile"
/// called on a holder when someone attempts to strike someone with a blade using that holder: (mob/wielder, obj/item/eldritch_blade/blade, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
#warn hook
#define COMSIG_ELDRITCH_HOLDER_BLADE_MELEE_IMPACT "eldritch-blade_melee_impact"
