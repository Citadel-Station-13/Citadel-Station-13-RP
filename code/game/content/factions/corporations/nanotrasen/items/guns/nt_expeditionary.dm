//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Caliber *//

/datum/ammo_caliber/nt_expeditionary
	abstract_type = /datum/ammo_caliber/nt_expeditionary

/datum/ammo_caliber/nt_expeditionary/light_sidearm
	caliber = "nt-light-sidearm"
	diameter = 9
	length = 29

/datum/ammo_caliber/nt_expeditionary/heavy_sidearm
	caliber = "nt-heavy-sidearm"
	diameter = 9
	length = 34

/datum/ammo_caliber/nt_expeditionary/light_rifle
	caliber = "nt-light-rifle"
	diameter = 7.5
	length = 39

/datum/ammo_caliber/nt_expeditionary/heavy_rifle
	caliber = "nt-heavy-rifle"
	diameter = 7.5
	length = 54

/datum/ammo_caliber/nt_expeditionary/antimaterial
	caliber = "nt-antimaterial"
	diameter = 12
	length = 92

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expeditionary
	description_fluff = {"
		A casing for the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort
		between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well
		as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an
		above-average reliability rating, as well as being easy to restock out on the Frontier.
	"}
	caliber = /datum/ammo_caliber/nt_expeditionary
	#warn stripe
	#warn sprites

//* Magazines *//

/obj/item/ammo_magazine/nt_expeditionary
	description_fluff = {"
		A casing for the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort
		between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well
		as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an
		above-average reliability rating, as well as being easy to restock out on the Frontier.
	"}
	ammo_caliber = /datum/ammo_caliber/nt_expeditionary

#warn impl
#warn sprites

//* Projectiles *//

/obj/projectile/bullet/nt_expeditionary

//* Weapons *//

/**
 * Naming scheme:
 *
 * XN<T> Mk.<V>
 *
 * Where 'T' is type, and 'V' is some version.
 *
 * e.g. XNS Mk.6 -> T = S for shotgun, prototype 6.
 */
/obj/item/gun/ballistic/nt_expeditionary
	description_fluff_categorizer = {"
		This weapon is part of the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an above-average reliability rating
		in addition to being rather simple to restock out on the Frontier.
	"}

#warn impl
