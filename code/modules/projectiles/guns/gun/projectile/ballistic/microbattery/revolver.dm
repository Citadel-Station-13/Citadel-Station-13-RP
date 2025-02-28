#warn purge

// The Gun //
/obj/item/gun/projectile/ballistic/microbattery/nt_hydra
	name = "cell-loaded revolver"
	desc = "Variety is the spice of life! The NT-102b 'Hydra' is an unholy hybrid of an ammo-driven  \
	energy weapon that allows the user to mix and match their own fire modes. Up to four combinations of \
	energy beams can be configured at once. Ammo not included."
	//catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)

	description_fluff = "The Nanotrasen 'Nanotech Selectable Fire Weapon' allows one to customize their loadout in the field, or before deploying, to achieve various results in a weapon they are already familiar with wielding."
	magazine_restrict = /obj/item/ammo_magazine/microbattery/nt_hydra

/obj/item/gun/projectile/ballistic/microbattery/nt_hydra/prototype
	name = "prototype cell-loaded revolver"
	desc = "Variety is the spice of life! A prototype based on NT-102b 'Hydra' for short, is an unholy hybrid of an ammo-driven  \
	energy weapon that allows the user to mix and match their own fire modes. Up to two combinations of \
	energy beams can be configured at once. Ammo not included."
	magazine_restrict = /obj/item/ammo_magazine/microbattery/nt_hydra/prototype

	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 4, TECH_MAGNETS = 3)


// The Magazine //
/obj/item/ammo_magazine/microbattery/nt_hydra
	name = "microbattery magazine"
	desc = "A microbattery holder for the \'Hydra\'"
	icon_state = "nsfw_mag"
	ammo_max = 4
	x_offset = 4
	catalogue_data = null//list(/datum/category_item/catalogue/information/organization/nanotrasen)
	ammo_restrict = /obj/item/ammo_casing/microbattery/combat

/obj/item/ammo_magazine/microbattery/nt_hydra/prototype
	name = "prototype microbattery magazine"
	icon_state = "nsfw_mag_prototype"
	ammo_max = 2
	x_offset = 6
	catalogue_data = null
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_MAGNETS = 2)

