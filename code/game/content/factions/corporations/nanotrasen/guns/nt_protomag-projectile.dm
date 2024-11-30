//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/image/projectile/nt_protomag_emissive
	icon_state = "kinetic-emissive"
	plane = EMISSIVE_PLANE
	layer = MANGLE_PLANE_AND_LAYER(/obj/projectile/nt_protomag::plane, /obj/projectile/nt_protomag::layer)

/obj/projectile/nt_protomag
	abstract_type = /obj/projectile/nt_protomag
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/protomag/projectile.dmi'
	icon_state = "kinetic"
	speed = /obj/projectile::speed * 1.1

/obj/projectile/nt_protomag/Initialize(mapload)
	. = ..()
	add_overlay(/image/projectile/nt_protomag_emissive)

/obj/projectile/nt_protomag/standard
	name = "magnetic slug"
	color = "#ccaa55"

/obj/projectile/nt_protomag/sabot
	name = "dense slug"
	color = "#ff7700"
	speed = /obj/projectile/nt_protomag::speed * 1.2

// todo: this is currently disabled as medcode is not verbose enough for this to work
// /obj/projectile/nt_protomag/shredder
// 	name = "fragmenting slug"

/obj/projectile/nt_protomag/impact
	name = "deforming slug"
	color = "#3333aa"
	speed = /obj/projectile/nt_protomag::speed * 0.9

/obj/projectile/nt_protomag/practice
	name = "lightweight slug"
	color = "#ffffff"
	damage_force = 5
	damage_tier = BULLET_TIER_LOW

/obj/projectile/nt_protomag/smoke
	name = "disintegrating slug"
	color = "#888888"
	speed = /obj/projectile/nt_protomag::speed * 0.6

/obj/projectile/nt_protomag/emp
	name = "ion slug"
	color = "#aaaaff"
	base_projectile_effects = list(
		/datum/projectile_effect/detonation/legacy_emp{
			sev_3 = 2;
		}
	)
	speed = /obj/projectile/nt_protomag::speed * 0.8

// todo: this is currently disabled as simplemobs are not complex-AI enough for us to do this, and we don't need a PVP-only tool
// /obj/projectile/nt_protomag/concussive
// 	name = "concussive slug"

/obj/projectile/nt_protomag/penetrator
	name = "high-velocity slug"
	color = "#aaffaa"
	speed = /obj/projectile/nt_protomag::speed * 1.25

/obj/projectile/nt_protomag/shock
	name = "piezo slug"
	color = "#cccc55"
	speed = /obj/projectile/nt_protomag::speed * 0.8

/obj/projectile/nt_protomag/flare
	name = "tracer shot"
	color = "#aa3333"
	speed = /obj/projectile/nt_protomag::speed * 0.6

// todo: fuck no, rework fire stacks / fire first, holy crap; even then this should take multiple hits to ignite.
// /obj/projectile/nt_protomag/incendiary
// 	name = "incendiary slug"

// todo: fuck no, not until chloral and chemicals are reworked; this round is meant to take like 2-3 units maximum, on that note.
// /obj/projectile/nt_protomag/reagent
// 	name = "chemical slug"

#warn impl all
