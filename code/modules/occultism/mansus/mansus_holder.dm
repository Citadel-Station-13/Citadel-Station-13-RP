//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Abstraction API between module and whatever role / mind system is on the side of mobs.
 * * It's valid to have more than one holder associated on a mob, but you shouldn't do so.
 */
/datum/mansus_holder
    /// known, researched knowledge IDs
    /// * serialized
    var/list/knowledge_known_ids = list()
    #warn passives
    #warn recipes
    #warn abilities
    #warn patrons

/datum/mansus_holder/proc/on_mob_associate(mob/target)

/datum/mansus_holder/proc/on_mob_disassociate(mob/target)

#warn impl
