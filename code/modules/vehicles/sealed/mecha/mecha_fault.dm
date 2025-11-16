//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * relatively stateless thingys
 * * can be stacked.
 */
/datum/mecha_fault

/datum/mecha_fault/proc/on_apply(obj/vehicle/sealed/mecha/mech)


/datum/mecha_fault/proc/on_remove(obj/vehicle/sealed/mecha/mech)

/datum/mecha_fault/proc/tick(obj/vehicle/sealed/mecha/mech, stacks = 1)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	on_tick(mech, stacks)

/datum/mecha_fault/proc/on_tick(obj/vehicle/sealed/mecha/mech, stacks)

#warn impl
