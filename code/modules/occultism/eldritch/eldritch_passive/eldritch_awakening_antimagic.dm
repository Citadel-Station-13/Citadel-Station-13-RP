//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_passive/eldritch_awakening_antimagic
	name = "Awakening - Reinforcement"
	desc = "Passive antimagic for eldritch cultists."

	var/datum/antimagic/antimagic_struct = new /datum/antimagic/simple_lienar/eldritch_awakening_antimagic

/datum/prototype/eldritch_passive/eldritch_awakening_antimagic/on_mob_associate(mob/cultist, datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	var/datum/component/antimagic_coverage/coverage_datum = cultist.antimagic_fetch_or_init_coverage()
	coverage_datum.add_source(antimagic_struct, antimagic_callback)

/datum/prototype/eldritch_passive/eldritch_awakening_antimagic/on_mob_disassociate(mob/cultist, datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	var/datum/component/antimagic_coverage/coverage_datum = cultist.antimagic_fetch_or_init_coverage()
	coverage_datum.remove_source(antimagic_struct)

#warn antimagic_callback

/datum/antimagic/simple_libear/eldritch_awakening_antimagic
	magic_types = MAGIC_TYPES_ALL
	full_block_potency = MAGIC_POTENCY_ELDRITCH_AWAKENING_ANTIMAGIC_BLOCK
	cant_block_potency = MAGIC_POTENCY_ELDRITCH_AWAKENING_ANTIMAGIC_NONE_BLOCK
