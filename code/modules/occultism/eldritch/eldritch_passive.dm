//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * ## Toggling
 *
 * If a passive can be toggled off and is toggled off, it will disassociate from a mob
 * and be removed from ticking.
 */
/datum/prototype/eldritch_passive
	abstract_type = /datum/prototype/eldritch_passive

	/// our name
	var/name = "???"
	/// our interface desc
	var/desc = "A perk granted by the infinite plane."
	/// our interface lore blurb; null for none
	var/lore

	/// our context type, if any
	var/context_type
	/// can be toggled on/off
	var/can_be_toggled = FALSE
	/// requires ticking?
	var/requires_ticking = FALSE

/datum/prototype/eldritch_passive/proc/create_initial_context(datum/eldritch_holder/holder) as /datum/eldritch_passive_context
	return context_type ? new context_type : null

/datum/prototype/eldritch_passive/proc/on_holder_enable(datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	return

/datum/prototype/eldritch_passive/proc/on_holder_disable(datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	return

/datum/prototype/eldritch_passive/proc/on_mob_associate(mob/cultist, datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	return

/datum/prototype/eldritch_passive/proc/on_mob_disassociate(mob/cultist, datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	return

/datum/prototype/eldritch_passive/proc/on_mob_tick(mob/cultist, datum/eldritch_holder/holder, datum/eldritch_passive_context/context, dt)
	return

/datum/prototype/eldritch_passive/proc/get_context_on_holder(datum/eldritch_holder/holder) as /datum/eldritch_passive_context
	return holder.applied_passives[id] || holder.disabled_passives[id]

/datum/prototype/eldritch_passive/proc/is_in_holder(datum/eldritch_holder/holder) as /datum/eldritch_passive_context
	return holder.applied_passives[id] || holder.disabled_passives[id]

/datum/prototype/eldritch_passive/proc/is_enabled_in_holder(datum/eldritch_holder/holder) as /datum/eldritch_passive_context
	return holder.applied_passives[id]

/datum/prototype/eldritch_passive/proc/is_disabled_in_holder(datum/eldritch_holder/holder) as /datum/eldritch_passive_context
	return holder.applied_passives[id]
