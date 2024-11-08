//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/ammo_casing/nt_protomag
	name = "protomag casing"
	desc = "An obnoxiously long casing for some kind of rifle."
	caliber = /datum/ammo_caliber/nt_protomag

/obj/item/ammo_casing/nt_protomag/magboosted
	name = "protomag round"
	desc = "A slender bullet. It seems to have less propellant than usual."
	casing_primer = CASING_PRIMER_MAGNETIC | CASING_PRIMER_CHEMICAL

/obj/item/ammo_casing/nt_protomag/magboosted/standard
	projectile_type = /obj/projectile/nt_protomag/standard

/obj/item/ammo_casing/nt_protomag/magboosted/sabot
	name = "protomag round (sabot)"
	desc = "A slender bullet. While lacking in stopping power, this round is designed to punch through thicker than usual armor."

	projectile_type = /obj/projectile/nt_protomag/sabot

// todo: this is currently disabled as medcode is not verbose enough for this to work
// /obj/item/ammo_casing/nt_protomag/magboosted/shredder
// 	name = "protomag round (shredder)"
// 	desc = "A slender bullet. While lacking in penetration, this round is designed to shred soft targets with ease."
//
//	projectile_type = /obj/projectile/nt_protomag/shredder

/obj/item/ammo_casing/nt_protomag/magboosted/impact
	name = "protomag round (impact)"
	desc = "A slender bullet. This round is the magnetic equivalent of a beanbag. That said, it would be a bad idea to detain someone with a railgun, beanbag or not."

	projectile_type = /obj/projectile/nt_protomag/impact

/obj/item/ammo_casing/nt_protomag/magboosted/practice
	name = "protomag round (practice)"
	desc = "A slender bullet. This round is just a practice round. While it is made out of relatively soft materials, you should still try to not get shot by this."

	projectile_type = /obj/projectile/nt_protomag/practice

/obj/item/ammo_casing/nt_protomag/magnetic
	name = "protomag slug"
	desc = "A slender ferromagnetic slug. A bullet without propellant, for whatever reason."
	casing_primer = CASING_PRIMER_MAGNETIC

/obj/item/ammo_casing/nt_protomag/magnetic/smoke
	name = "protomag slug (smoke)"
	desc = "A slender ferromagnetic slug. While lacking in penetration, this round releases a light smokescreen on impact."

	projectile_type = /obj/projectile/nt_protomag/smoke

/obj/item/ammo_casing/nt_protomag/magnetic/emp
	name = "protomag slug (emp)"
	desc = "A slender ferromagnetic slug. While lacking in penetration, this round releases a small electromagnetic burst on impact."

	projectile_type = /obj/projectile/nt_protomag/emp

// todo: this is currently disabled as simplemobs are not complex-AI enough for us to do this, and we don't need a PVP-only tool
// /obj/item/ammo_casing/nt_protomag/magnetic/concussive
// 	name = "protomag slug (concussive)"
// 	desc = "A slender ferromagnetic slug. While lacking in penetration, this round contains a small airburst charge that detonates on impact."

// 	projectile_type = /obj/projectile/nt_protomag/concussive

/obj/item/ammo_casing/nt_protomag/magnetic/penetrator
	name = "protomag slug (penetrator)"
	desc = "A slender ferromagnetic slug. This one is made out of dense alloys, and is designed to punch through materials with ease. This round has very high recoil, as well as power draw."

	projectile_type = /obj/projectile/nt_protomag/penetrator

/obj/item/ammo_casing/nt_protomag/magnetic/shock
	name = "protomag slug (shock)"
	desc = "A slender ferromagnetic slug. This one is designed to release a burst of energy on imapct for less-than-lethal takedowns. That said, it would probably still be a bad idea to detain someone with a railgun slug."

	projectile_type = /obj/projectile/nt_protomag/shock

/obj/item/ammo_casing/nt_protomag/magnetic/flare
	name = "protomag slug (flare)"
	desc = "A slender ferromagnetic slug. Shatters into a lingering chemical illuminant on impact."

	projectile_type = /obj/projectile/nt_protomag/flare

// todo: fuck no, rework fire stacks / fire first, holy crap; even then this should take multiple hits to ignite.
// /obj/item/ammo_casing/nt_protomag/magnetic/incendiary
// 	name = "protomag slug (incendiary)"
// 	desc = "A slender ferromagnetic slug. With almost no penetrating power whatsoever, this round is designed to explode into an incendiary material on impact"

// 	projectile_type = /obj/projectile/nt_protomag/incendiary

// todo: fuck no, not until chloral and chemicals are reworked; this round is meant to take like 2-3 units maximum, on that note.
// /obj/item/ammo_casing/nt_protomag/magnetic/reagent
// 	name = "protomag slug (chemical)"
// 	desc = "A slender ferromagnetic slug. Can be laced with a small amount of reagents, which will then splash onto and be injected into a hit target."

// 	projectile_type = /obj/projectile/nt_protomag/reagent

#warn impl all
