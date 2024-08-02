//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Modular mag-boosted weapons, courtesy of the Nanotrasen Research Division.
 */
/obj/item/gun/ballistic/magnetic/modular/nt_protomag
	abstract_type = /obj/item/gun/ballistic/magnetic/modular/nt_protomag
	description_fluff = {"
		An experimental magnetic weapon from the Nanotrasen Research Division. The 'protomag' series uses specially
		made ammunition capable of a hybrid launch, combining conventional propellant with an accelerating burst
		from a set of acceleration coils to throw a slug down-range. While still lacking in ammo capacity,
		this 'prototype' is already made in many Nanotrasen fleets for day-to-day usage. As of recent, designs
		for specialized cartridges have been released for field testing, though many of said rounds require
		a large amount of energy to discharge, in contrast to more normal hybrid rounds.
	"}

#warn sounds for everything

//* Sidearm *//

#warn impl all

/obj/item/gun/ballistic/magnetic/modular/nt_protomag/sidearm
	name = "protomag sidearm"
	desc = "A modular ferromagnetic-boosted weapon. Uses experimental ferromagnetic ammunition."

//* Rifle *//

#warn impl all

/obj/item/gun/ballistic/magnetic/modular/nt_protomag/rifle
	name = "protomag rifle"
	desc = "A modular ferromagnetic-boosted weapon. Uses experimental ferromagnetic ammunition"

//* Caliber *//

// todo: proper diameter/length def
/datum/caliber/nt_protomag
	caliber = "nt-protomag"

//* Ammo & Projectiles *//

/obj/item/ammo_casing/nt_protomag
	name = "protomag casing"
	desc = "An obnoxiously long casing for some kind of rifle."
	caliber = /datum/caliber/nt_protomag

/obj/projectile/bullet/nt_protomag
	#warn impl all

#warn impl all, with boxes, and colors. how?

/obj/item/ammo_casing/nt_protomag/magboosted
	name = "protomag round"
	desc = "A slender bullet. It seems to have less propellant than usual."
	casing_primer = CASING_PRIMER_MAGNETIC | CASING_PRIMER_CHEMICAL

/obj/item/ammo_casing/nt_protomag/magboosted/sabot
	name = "protomag round (sabot)"
	desc = "A slender bullet. While lacking in stopping power, this round is designed to punch through thicker than usual armor."

// todo: this is currently disabled as medcode is not verbose enough for this to work
// /obj/item/ammo_casing/nt_protomag/magboosted/shredding
// 	name = "protomag round (shredder)"
// 	desc = "A slender bullet. While lacking in penetration, this round is designed to shred soft targets with ease."

/obj/item/ammo_casing/nt_protomag/magboosted/impact
	name = "protomag round (impact)"
	desc = "A slender bullet. This round is the magnetic equivalent of a beanbag. That said, it would be a bad idea to detain someone with a railgun, beanbag or not."

/obj/item/ammo_casing/nt_protomag/magboosted/practice
	name = "protomag round (practice)"
	desc = "A slender bullet. This round is just a practice round. While it is made out of relatively soft materials, you should still try to not get shot by this."

/obj/item/ammo_casing/nt_protomag/magnetic
	name = "protomag slug"
	desc = "A slender ferromagnetic slug. A bullet without propellant, for whatever reason."
	casing_primer = CASING_PRIMER_MAGNETIC

/obj/item/ammo_casing/nt_protomag/magnetic/smoke
	name = "protomag slug (smoke)"
	desc = "A slender ferromagnetic slug. While lacking in penetration, this round releases a light smokescreen on impact."

/obj/item/ammo_casing/nt_protomag/magnetic/emp
	name = "protomag slug (emp)"
	desc = "A slender ferromagnetic slug. While lacking in penetration, this round releases a small electromagnetic burst on impact."

// todo: this is currently disabled as simplemobs are not complex-AI enough for us to do this, and we don't need a PVP-only tool
// /obj/item/ammo_casing/nt_protomag/magnetic/concussive
// 	name = "protomag slug (concussive)"
// 	desc = "A slender ferromagnetic slug. While lacking in penetration, this round contains a small airburst charge that detonates on impact."

/obj/item/ammo_casing/nt_protomag/magnetic/penetrator
	name = "protomag slug (penetrator)"
	desc = "A slender ferromagnetic slug. This one is made out of dense alloys, and is designed to punch through materials with ease. This round has very high recoil, as well as power draw."

/obj/item/ammo_casing/nt_protomag/magnetic/shock
	name = "protomag slug (shock)"
	desc = "A slender ferromagnetic slug. This one is designed to release a burst of energy on imapct for less-than-lethal takedowns. That said, it would probably still be a bad idea to detain someone with a railgun slug."

/obj/item/ammo_casing/nt_protomag/magnetic/flare
	name = "protomag slug (flare)"
	desc = "A slender ferromagnetic slug. Shatters into a lingering chemical illuminant on impact."

// todo: fuck no, rework fire stacks / fire first, holy crap; even then this should take multiple hits to ignite.
// /obj/item/ammo_casing/nt_protomag/magnetic/incendiary
// 	name = "protomag slug (incendiary)"
// 	desc = "A slender ferromagnetic slug. With almost no penetrating power whatsoever, this round is designed to explode into an incendiary material on impact"

// todo: fuck no, not until chloral and chemicals are reworked; this round is meant to take like 2-3 units maximum, on that note.
// /obj/item/ammo_casing/nt_protomag/magnetic/reagent
// 	name = "protomag slug (chemical)"
// 	desc = "A slender ferromagnetic slug. Can be laced with a small amount of reagents, which will then splash onto and be injected into a hit target."

/obj/item/ammo_casing/nt_protomag/magnetic/flare

#warn impl all

//* Magazine *//

/obj/item/ammo_magazine/nt_protomag
	desc = "A magazine for a magnetic weapon of some kind."
	ammo_caliber = /datum/caliber/nt_protomag

#warn first two should fit in webbing, but not boxes

/obj/item/ammo_magazine/nt_protomag/sidearm
	name = "protomag sidearm magazine"
	ammo_max = 8

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_TINY
	slot_flags = SLOT_POCKET

/obj/item/ammo_magazine/nt_protomag/rifle
	name = "protomag rifle magazine"
	ammo_max = 16

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_SMALL
	slot_flags = SLOT_POCKET

/obj/item/ammo_magazine/nt_protomag/box
	name = "protomag ammo box"
	desc = "A box of experimental magnetic ammunition."
	ammo_max = 32

	w_class = WEIGHT_CLASS_NORMAL // no boxes
	weight_volume = WEIGHT_VOLUME_NORMAL
	slot_flags = SLOT_POCKET

#warn impl all
