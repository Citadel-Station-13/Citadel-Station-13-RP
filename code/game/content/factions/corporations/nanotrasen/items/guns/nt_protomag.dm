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
	name = "ammo casing"
	desc = "An obnoxiously long casing for some kind of rifle."
	caliber = /datum/caliber/nt_protomag

/obj/item/ammo_casing/nt_protomag/magboosted
	name = "metallic casing"
	desc = "A slender bullet. It seems to have less propellant than usual."
	casing_primer = CASING_PRIMER_MAGNETIC | CASING_PRIMER_CHEMICAL

/obj/item/ammo_casing/nt_protomag/magnetic
	name = "metallic slug"
	desc = "A slender ferromagnetic slug. A bullet without propellant, for whatever reason."
	casing_primer = CASING_PRIMER_MAGNETIC



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
