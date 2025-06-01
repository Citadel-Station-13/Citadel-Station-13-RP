//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/effect/mansus_effect/reality_disturbance
	name = "ripple in the fabric of reality"
	desc = "???"

/obj/effect/mansus_effect/reality_disturbance/Initialize(mapload)
	var/list/random_names = list(
		"ripple in the fabric of reality",
		"disturbance in reality",
		"weakness in the fabric of reality",
		"breach to the infinite corridor",
	)
	name = pick(random_names)
	return ..()

/obj/effect/mansus_effect/reality_disturbance/examine(mob/user, dist)
	. = ..()

/obj/effect/mansus_effect/reality_disturbance/on_attack_hand(datum/event_args/actor/clickchain/e_args)
	. = ..()


#warn general todo: examine tweaks so other people can't see certain things and/or what someone's looking at

#warn impl partial

/**
 * Called when a heretic fractures us.
 */
/obj/effect/mansus_effect/reality_disturbance/proc/fracture(datum/event_args/actor/by_actor, datum/mansus_holder/by_holder)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	create_fracture(by_actor, by_holder)
	qdel(src)

/**
 * @return /obj/effect/mansus_effect/reality_fracture
 */
/obj/effect/mansus_effect/reality_disturbance/proc/create_fracture(datum/event_args/actor/by_actor, datum/mansus_holder/by_holder)

	var/obj/effect/mansus_effect/reality_fracture/created_fracture = new(loc, src)
	return created_fracture
