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

#warn general todo: examine tweaks so other people can't see certain things and/or what someone's looking at

#warn impl partial
