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

/obj/item/ammo_casing/nt_expeditionary/pistol_light
	name = "ammo casing (NT-9)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight pistols and sidearms."
	caliber = /datum/ammo_caliber/nt_expeditionary/light_sidearm

/obj/item/ammo_casing/nt_expeditionary/pistol_heavy
	name = "ammo casing (NT-9-magnum)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy-duty sidearms."
	caliber = /datum/ammo_caliber/nt_expeditionary/heavy_sidearm

/obj/item/ammo_casing/nt_expeditionary/rifle_light
	name = "ammo casing (NT-7.5-SR)"
	desc = "A standardized 7.5x39mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight automatics."
	caliber = /datum/ammo_caliber/nt_expeditionary/light_rifle

/obj/item/ammo_casing/nt_expeditionary/rifle_heavy
	name = "ammo casing (NT-7.5-LR)"
	desc = "A standardized 7.5x54mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy rifles."
	caliber = /datum/ammo_caliber/nt_expeditionary/heavy_rifle

/obj/item/ammo_casing/nt_expeditionary/antimaterial
	name = "ammo casing (NT-12.5-antimaterial)"
	desc = "A standardized 12.5x92mm cartridge for NT Expeditionary kinetics. This one seems ridiculous large, and is probably for a very powerful weapon."
	caliber = /datum/ammo_caliber/nt_expeditionary/antimaterial

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
