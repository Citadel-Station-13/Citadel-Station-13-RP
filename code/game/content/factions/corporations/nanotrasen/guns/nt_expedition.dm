//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Caliber *//

/datum/ammo_caliber/nt_expedition
	abstract_type = /datum/ammo_caliber/nt_expedition

//* Ammo Casings *//

/obj/item/ammo_casing/nt_expedition
	abstract_type = /obj/item/ammo_casing/nt_expedition
	description_fluff = {"
		A casing for the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort
		between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well
		as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an
		above-average reliability rating, as well as being easy to restock out on the Frontier.
	"}
	casing_caliber = /datum/ammo_caliber/nt_expedition

//* Magazines *//

/obj/item/ammo_magazine/nt_expedition
	description_fluff = {"
		A magazine for the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort
		between Hephaestus Industries and the Nanotrasen Research Division. Created both to enhance compatibility as well
		as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an
		above-average reliability rating, as well as being easy to restock out on the Frontier.
	"}
	ammo_caliber = /datum/ammo_caliber/nt_expedition

//* Projectiles *//

/obj/projectile/bullet/nt_expedition

//* Design Generation *//

/datum/prototype/design/generated/nt_expedition
	abstract_type = /datum/prototype/design/generated/nt_expedition
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_BALLISTIC

/datum/prototype/design/generated/nt_expedition_ammo
	abstract_type = /datum/prototype/design/generated/nt_expedition_ammo
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_AMMO

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
/obj/item/gun/projectile/ballistic/nt_expedition
	description_fluff_categorizer = {"
		This weapon is part of the experimental lineage of chemical-primed kinetic weaponry developed as part of a joint effort between Hephaestus Industries and the Nanotrasen Research Division.
		Created both to enhance compatibility as well as to improve security on installations operated by the Triumvirate, the 'NT Expeditionary' line boasts an above-average reliability rating
		in addition to being rather simple to restock out on the Frontier.
	"}
	item_renderer = /datum/gun_item_renderer/nothing
