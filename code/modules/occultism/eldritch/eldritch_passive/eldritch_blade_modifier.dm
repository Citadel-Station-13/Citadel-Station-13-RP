//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_passive/eldritch_blade_modifier
	abstract_type = /datum/prototype/eldritch_passive/eldritch_blade_modifier

#warn impl

/datum/prototype/eldritch_passive/eldritch_blade_modifier/on_holder_enable(datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	RegisterSignal(holder, COMSIG_ELDRITCH_HOLDER_BLADE_MELEE_IMPACT, PROC_REF(on_blade_melee_impact))

/datum/prototype/eldritch_passive/eldritch_blade_modifier/on_holder_disable(datum/eldritch_holder/holder, datum/eldritch_passive_context/context)
	..()
	UnregisterSignal(holder, COMSIG_ELDRITCH_HOLDER_BLADE_MELEE_IMPACT)

/datum/prototype/eldritch_passive/eldritch_blade_modifier/proc/on_blade_melee_impact(datum/eldritch_holder/source, mob/wielder, obj/item/eldritch_blade/blade, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return
