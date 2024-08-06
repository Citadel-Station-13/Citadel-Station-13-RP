//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Caliber *//

/datum/caliber/nt_expeditionary
	abstract_type = /datum/caliber/nt_expeditionary

/datum/caliber/nt_expeditionary/pistol_light
	caliber = "nt-pistol-light"
	diameter = 9
	length = 29

/datum/caliber/nt_expeditionary/pistol_heavy
	caliber = "nt-pistol-heavy"
	diameter = 9
	length = 34

/datum/caliber/nt_expeditionary/rifle_light
	caliber = "nt-rifle-light"
	diameter = 7.5
	length = 39

/datum/caliber/nt_expeditionary/rifle_heavy
	caliber = "nt-rifle-heavy"
	diameter = 7.5
	length = 54

/datum/caliber/nt_expeditionary/antimaterial
	caliber = "nt-antimaterial"
	diameter = 12
	length = 92

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expeditionary
	description_fluff = {"
		A casing for the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort
		between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well
		as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an
		above-average reliability rating, as well as being easy to restock out on the Frontier.
	"}
	#warn stripe
	#warn sprites

/obj/item/ammo_casing/nt_expeditionary/pistol_light
	name = "ammo casing (NT-9)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight pistols and sidearms."

/obj/item/ammo_casing/nt_expeditionary/pistol_heavy
	name = "ammo casing (NT-9-magnum)"
	desc = "A standardized 9mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy-duty sidearms."

/obj/item/ammo_casing/nt_expeditionary/rifle_light
	name = "ammo casing (NT-7.5-SR)"
	desc = "A standardized 7.5x39mm cartridge for NT Expeditionary kinetics. This one seems to be for lightweight automatics."

/obj/item/ammo_casing/nt_expeditionary/rifle_heavy
	name = "ammo casing (NT-7.5-LR)"
	desc = "A standardized 7.5x54mm cartridge for NT Expeditionary kinetics. This one seems to be for heavy rifles."

/obj/item/ammo_casing/nt_expeditionary/antimaterial
	name = "ammo casing (NT-12.5-antimaterial)"
	desc = "A standardized 12.5x92mm cartridge for NT Expeditionary kinetics. This one seems ridiculous large, and is probably for a very powerful weapon."

//* Magazines *//

/obj/item/ammo_magazine/nt_expeditionary
	caliber = /datum/ammo_caliber/nt_expeditionary

#warn impl
#warn sprites
