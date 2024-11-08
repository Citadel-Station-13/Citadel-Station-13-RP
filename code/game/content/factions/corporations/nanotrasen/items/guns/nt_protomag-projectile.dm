//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/projectile/nt_protomag
	abstract_type = /obj/projectile/nt_protomag

/obj/projectile/nt_protomag/standard

/obj/projectile/nt_protomag/sabot
	name = "magnetic slug"

// todo: this is currently disabled as medcode is not verbose enough for this to work
// /obj/projectile/nt_protomag/shredder
// 	name = "fragmenting slug"

/obj/projectile/nt_protomag/impact
	name = "deforming slug"

/obj/projectile/nt_protomag/practice
	name = "lightweight slug"

/obj/projectile/nt_protomag/smoke
	name = "disintegrating slug"

/obj/projectile/nt_protomag/emp
	name = "ion slug"
	base_projectile_effects = list(
		/datum/projectile_effect/detonation/legacy_emp{
			sev_3 = 2;
		}
	)

// todo: this is currently disabled as simplemobs are not complex-AI enough for us to do this, and we don't need a PVP-only tool
// /obj/projectile/nt_protomag/concussive
// 	name = "concussive slug"

/obj/projectile/nt_protomag/penetrator
	name = "high-velocity slug"

/obj/projectile/nt_protomag/shock
	name = "piezo slug"

/obj/projectile/nt_protomag/flare
	name = "tracer shot"

// todo: fuck no, rework fire stacks / fire first, holy crap; even then this should take multiple hits to ignite.
// /obj/projectile/nt_protomag/incendiary
// 	name = "incendiary slug"

// todo: fuck no, not until chloral and chemicals are reworked; this round is meant to take like 2-3 units maximum, on that note.
// /obj/projectile/nt_protomag/reagent
// 	name = "chemical slug"

#warn impl all
