//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

// todo: burn all this shit with fire

/// used by passive parry to detect
/// the entire mob item attack system is a dumpster fire and needs rewritten
/// for now, this is a signal with (item, user, hit_zone)
#define COMSIG_MOB_LEGACY_RESOLVE_ITEM_ATTACK "legacy-mob-item-resolve-attack"
/// used by passive parry to detect
/// signal with (user, datum/event_args/actor/clickchain/e_args)
/// :skull:
#define COMSIG_MOB_LEGACY_ATTACK_HAND_INTERCEPT "legacy-mob-legacy-attack-hand"
