//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_passive/eldritch_antimagic
	abstract_type = /datum/prototype/eldritch_passive/eldirtch_antimagic

	var/datum/antimagic/antimagic_struct = new /datum/antimagic/simple_linear/eldritch_awakening_antimagic
	var/datum/callback/antimagic_callback

/datum/prototype/eldritch_passive/eldritch_antimagic/New()
	..()
	antimagic_callback = CALLBACK(src, PROC_REF(on_antimagic_invoke))

/datum/prototype/eldritch_passive/eldritch_antimagic/Destroy()
	antimagic_callback = null
	return ..()

/datum/prototype/eldritch_passive/eldritch_antimagic/on_mob_associate(mob/cultist, datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	var/datum/component/antimagic_coverage/coverage_datum = cultist.antimagic_fetch_or_init_coverage()
	coverage_datum.add_source(antimagic_struct, antimagic_callback)

/datum/prototype/eldritch_passive/eldritch_antimagic/on_mob_disassociate(mob/cultist, datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	var/datum/component/antimagic_coverage/coverage_datum = cultist.antimagic_fetch_or_init_coverage()
	coverage_datum.remove_source(antimagic_struct)

/datum/prototype/eldritch_passive/eldritch_antimagic/proc/on_antimagic_invoke(datum/antimagic/source, list/antimagic_args)
	return

/datum/antimagic/simple_linear/eldritch_antimagic
