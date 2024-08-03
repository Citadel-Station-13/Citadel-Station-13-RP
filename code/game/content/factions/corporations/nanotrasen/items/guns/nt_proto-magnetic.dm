//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * Modular mag-boosted weapons, courtesy of the Nanotrasen Research Division.
 */
/obj/item/gun/ballistic/magnetic/modular/nt_proto
	abstract_type = /obj/item/gun/ballistic/magnetic/modular/nt_proto

//* Sidearm *//

#warn impl all

/obj/item/gun/ballistic/magnetic/modular/nt_proto/sidearm
	name = "prototype magpistol"
	desc = "A modular ferromagnetic-boosted weapon. Uses "

//* Rifle *//

#warn impl all

/obj/item/gun/ballistic/magnetic/modular/nt_proto/rifle
	name = "prototype magrifle"
	desc = "A modular ferromagnetic-boosted weapon. Uses experimental "

//* Ammo *//

/obj/item/ammo_casing/a7_75mm/nt_proto/magboosted
	name = "metallic casing"
	desc = "A long, thin bullet. It seems to have less propellant than usual."
	casing_primer = CASING_PRIMER_MAGNETIC | CASING_PRIMER_CHEMICAL

/obj/item/ammo_casing/a7_75mm/nt_proto/magnetic
	name = "metallic slug"
	desc = "A long, thin, aerodynamic slug. A bullet without propellant, for whatever reason."
	casing_primer = CASING_PRIMER_MAGNETIC



#warn impl all

//* Projectiles *//

#warn impl all

//* Magazine *//

/obj/item/ammo_magazine/a7_75mm/nt_proto/magnetic

#warn impl all
