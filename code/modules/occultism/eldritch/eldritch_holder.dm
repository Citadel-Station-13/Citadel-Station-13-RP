//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Abstraction API between module and whatever role / mind system is on the side of mobs.
 * * It's valid to have more than one holder associated on a mob, but you shouldn't do so.
 */
/datum/eldritch_holder
	/// our active mob
	var/mob/owner

	/// known, researched knowledge IDs
	/// * serialized
	var/list/knowledge_known_ids = list()
	/// passives applied
	#warn passives
	var/tmp/list/datum/eldritch_passive/applied_passives
	/// recipe ids known
	#warn recipes? should this be ids?
	var/tmp/list/applied_recipe_ids
	/// abilities applied
	#warn abilities
	var/tmp/list/datum/eldritch_ability/applied_abilities


	#warn patrons

/datum/eldritch_holder/proc/on_mob_associate(mob/target)


/datum/eldritch_holder/proc/on_mob_disassociate(mob/target)

/datum/eldritch_holder/proc/on_life_tick(dt)

#warn impl

/datum/eldritch_holder/proc/add_knowledge(datum/eldritch_knowledge/knowledge)

/datum/eldritch_holder/proc/remove_knowledge(datum/eldritch_knowledge/knowledge)
