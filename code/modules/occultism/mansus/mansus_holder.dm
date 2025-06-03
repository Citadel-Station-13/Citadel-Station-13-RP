//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Abstraction API between module and whatever role / mind system is on the side of mobs.
 * * It's valid to have more than one holder associated on a mob, but you shouldn't do so.
 */
/datum/mansus_holder
	/// our active mob
	var/mob/owner

	/// known, researched knowledge IDs
	/// * serialized
	var/list/knowledge_known_ids = list()
	/// passives applied
	#warn passives
	var/list/datum/mansus_passive/applied_passives
	/// recipe ids known
	#warn recipes
	var/list/applied_recipe_ids
	/// abilities applied
	#warn abilities
	var/list/datum/mansus_ability/applied_abilities


	#warn patrons

/datum/mansus_holder/proc/on_mob_associate(mob/target)

/datum/mansus_holder/proc/on_mob_disassociate(mob/target)

/datum/mansus_holder/proc/on_life_tick(dt)

#warn impl
