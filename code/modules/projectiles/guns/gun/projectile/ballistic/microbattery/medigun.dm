#warn purge

// The Gun //
/obj/item/gun/projectile/ballistic/microbattery/vm_aml
	name = "cell-loaded medigun"
	desc = "The Nanotrasen-VayMed Adaptive Medical Laser, or the NT-V 'AML', is a powerful cell-based ranged healing device designed by Nanotrasen with a partnership with Vey-Med. It uses an internal nanite fabricator, powered and controlled by discrete cells, to deliver a variety of effects at range. Up to six combinations of healing beams can be configured at once, depending on cartridge used. Ammo not included."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)

	icon_state = "ml3m"
	description_info = "This is a ranged healing device that uses interchangable nanite discharge cells in a magazine. Each cell is a different healing beam type, and up to three can be loaded in the magazine. Each battery usually provides four discharges of that beam type, and multiple from the same type may be loaded to increase the number of shots for that type."
	description_fluff = "The Vey-Med AML 'Medigun' allows one to customize their loadout in the field, or before deploying, to allow emergency response personnel to deliver a variety of ranged healing options."
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_BIO = 5)
	magazine_restrict = /obj/item/ammo_magazine/microbattery/medical
	no_pin_required = 1

/obj/item/gun/projectile/ballistic/microbattery/vm_aml/cmo
	name = "advanced cell-loaded medigun"
	desc = "This is a variation on the AML 'Medigun', a powerful cell-based ranged healing device based on the same model made by Nanotrasen and Vey-Med \
	It has an extended sight for increased accuracy, and much more comfortable grip. Ammo not included."

	icon_state = "ml3m_cmo"


// The Magazine //
/obj/item/ammo_magazine/microbattery/medical //medical
	name = "nanite magazine"
	desc = "A nanite fabrication magazine for the \'AML'"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)
	description_info = "This magazine holds self-charging nanite fabricators to power the AML 'Medigun'. Up to three can be loaded at once, and each provides four shots of their respective healing type. Loading multiple of the same type will provide additional shots of that type. The batteries can be recharged in a normal recharger."
	ammo_restrict = /obj/item/ammo_casing/microbattery/vm_aml
	icon_state = "ml3m_mag"

/obj/item/ammo_magazine/microbattery/medical/advanced
	name = "advanced nanite magazine"
	desc = "A nanite discharge cell for the \'AML\'. This one is a more advanced version which can hold six individual nanite discharge cells."
	ammo_max = 6
	x_offset = 3
	icon_state = "ml3m_mag_extended"
