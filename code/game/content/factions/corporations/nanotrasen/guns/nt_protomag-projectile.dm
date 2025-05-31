//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/image/projectile/nt_protomag_emissive
	icon_state = "kinetic-emissive"
	appearance_flags = KEEP_APART | RESET_COLOR
	plane = EMISSIVE_PLANE
	layer = MANGLE_PLANE_AND_LAYER(/obj/projectile/nt_protomag::plane, /obj/projectile/nt_protomag::layer)
	color = EMISSIVE_COLOR

/image/projectile/nt_protomag_add
	icon_state = "kinetic-add"
	appearance_flags = KEEP_APART | RESET_COLOR

/obj/projectile/nt_protomag
	abstract_type = /obj/projectile/nt_protomag
	icon = 'icons/content/factions/corporations/nanotrasen/items/guns/protomag/projectile.dmi'
	icon_state = "kinetic"
	SET_APPEARANCE_FLAGS(KEEP_TOGETHER)
	speed = /obj/projectile::speed * 1.1

	impact_sound = PROJECTILE_IMPACT_SOUNDS_KINETIC

	var/penalized = FALSE

	var/penalty_speed_multiplier = 1
	var/penalty_damage_multiplier = 1
	var/penalty_damage_tier

/obj/projectile/nt_protomag/Initialize(mapload)
	. = ..()
	add_overlay(/image/projectile/nt_protomag_emissive)
	add_overlay(/image/projectile/nt_protomag_add)

/**
 * Called when fired without magnetic boosting.
 */
/obj/projectile/nt_protomag/proc/penalize()
	damage_force *= penalty_damage_multiplier
	if(!isnull(penalty_damage_tier))
		damage_tier = penalty_damage_tier
	speed *= penalty_speed_multiplier
	penalized = TRUE

/obj/projectile/nt_protomag/standard
	name = "magnetic slug"
	color = "#ccaa55"
	damage_force = 35
	damage_tier = 4
	penalty_speed_multiplier = 3 / 4
	penalty_damage_tier = 3.25

/obj/projectile/nt_protomag/sabot
	name = "dense slug"
	color = "#ff7700"
	speed = /obj/projectile/nt_protomag::speed * 1.2
	damage_force = 30
	damage_tier = 5
	penalty_speed_multiplier = 4 / 5
	damage_tier = 4

// todo: this is currently disabled as medcode is not verbose enough for this to work
// /obj/projectile/nt_protomag/shredder
// 	name = "fragmenting slug"

/obj/projectile/nt_protomag/impact
	name = "deforming slug"
	color = "#3333aa"
	speed = /obj/projectile/nt_protomag::speed * 0.9
	damage_force = 10
	damage_tier = 4
	damage_inflict_agony = 30
	penalty_speed_multiplier = 3 / 4
	penalty_damage_tier = 3.25

/obj/projectile/nt_protomag/practice
	name = "lightweight slug"
	color = "#ffffff"
	damage_force = 5
	damage_tier = 2.5

// todo: i refuse to do this until i can make it pretty
// /obj/projectile/nt_protomag/smoke
// 	name = "disintegrating slug"
// 	color = "#888888"
// 	speed = /obj/projectile/nt_protomag::speed * 0.6
// 	damage_force = 5
// 	damage_tier = BULLET_TIER_LOW
// 	#warn smoke

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
	damage_force = 30
	damage_tier = 6

// todo: the impulse should be semi armor piercing
/obj/projectile/nt_protomag/shock
	name = "piezo slug"
	color = "#cccc55"
	speed = /obj/projectile/nt_protomag::speed * 0.8
	damage_force = 10
	damage_tier = 4.25
	base_projectile_effects = list(
		/datum/projectile_effect/electrical_impulse{
			shock_damage = 15;
			shock_agony = 30;
			shock_energy = 50;
			shock_flags = ELECTROCUTE_ACT_FLAG_DISTRIBUTE | ELECTROCUTE_ACT_FLAG_DO_NOT_STUN;
		}
	)

// todo: flare rounds should illuminate the target and a bit of the surroundings with
//       a weak glow. bright pyrotechnics would not fit into the round.
// /obj/projectile/nt_protomag/flare
// 	name = "tracer shot"
// 	color = "#aa3333"
// 	speed = /obj/projectile/nt_protomag::speed * 0.6
// 	damage_force = 5
// 	damage_tier = BULLET_TIER_LOW

// todo: fuck no, rework fire stacks / fire first, holy crap; even then this should take multiple hits to ignite.
// /obj/projectile/nt_protomag/incendiary
// 	name = "incendiary slug"

// todo: fuck no, not until chloral and chemicals are reworked; this round is meant to take like 2-3 units maximum, on that note.
// /obj/projectile/nt_protomag/reagent
// 	name = "chemical slug"
