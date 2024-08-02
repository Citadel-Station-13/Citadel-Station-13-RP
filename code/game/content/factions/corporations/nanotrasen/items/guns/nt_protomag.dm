//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Modular mag-boosted weapons, courtesy of the Nanotrasen Research Division.
 */
/obj/item/gun/ballistic/magnetic/modular/nt_protomag
	abstract_type = /obj/item/gun/ballistic/magnetic/modular/nt_protomag

//* Sidearm *//

#warn impl all

/obj/item/gun/ballistic/magnetic/modular/nt_protomag/sidearm
	name = "prototype magpistol"
	desc = "A modular ferromagnetic-boosted weapon. Uses "

//* Rifle *//

#warn impl all

/obj/item/gun/ballistic/magnetic/modular/nt_protomag/rifle
	name = "prototype magrifle"
	desc = "A modular ferromagnetic-boosted weapon. Uses experimental "

//* Caliber *//

// todo: proper diameter/length def
/datum/caliber/nt_protomag
	caliber = "nt-protomag"

//* Ammo *//

/obj/item/ammo_casing/nt_protomag
	name = "protomag casing"
	desc = "An obnoxiously long casing for some kind of rifle."
	caliber = /datum/caliber/nt_protomag

/obj/item/ammo_casing/nt_protomag/magboosted
	name = "protomag round"
	desc = "A slender bullet. It seems to have less propellant than usual."
	casing_primer = CASING_PRIMER_MAGNETIC | CASING_PRIMER_CHEMICAL

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
	desc = "A slender ferromagnetic slug. This one lacks stopping power, but can punch through some materials with ease."

/obj/item/ammo_casing/nt_protomag/magnetic/shock
	name = "protomag slug (shock)"
	desc = "A slender ferromagnetic slug. Surely, actually trying to detain someone with a railgun is a bad idea, right?"

/obj/item/ammo_casing/nt_protomag/magnetic/flare
	name = "protomag slug (flare)"
	desc = "A slender ferromagnetic slug. Shatters into a lingering chemical illuminant on impact."


#warn impl all

//* Projectiles *//

#warn impl all

//* Magazine *//

/obj/item/ammo_magazine/nt_protomag
	#warn name?
	desc = "A lightweight magazine for some kind of rifle."
	ammo_caliber = /datum/caliber/nt_protomag

/obj/item/ammo_magazine/nt_protomag/magnetic

#warn impl all
