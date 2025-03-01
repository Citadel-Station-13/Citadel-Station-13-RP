//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/projectile/sealant
	name = "sealant glob"
	desc = "A glob of sealant. Doesn't look pleasant to be hit by."
	icon = 'icons/modules/sealant_gun/sealant_glob.dmi'
	icon_state = "projectile"

#warn impl

/obj/projectile/sealant/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()

	// todo: use /obj/effect/temp_visual/sealant_splat
