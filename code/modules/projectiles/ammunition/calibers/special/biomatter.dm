/datum/ammo_caliber/biomatter
	id = "biomatter"
	caliber = "biomatter"

/obj/item/ammo_casing/biomatter
	name = "biomatter globule"
	desc = "Globular biomatter rendered and ready for compression."
	casing_caliber = /datum/ammo_caliber/biomatter

	icon = 'icons/modules/projectiles/casings/bio.dmi'
	icon_state = "globule"
	icon_spent = FALSE

	color = "#FFE0E2"
	projectile_type = /obj/projectile/bullet/organic
	materials_base = list("flesh" = 100)

	casing_flags = CASING_DELETE

/obj/item/ammo_magazine/biomatter
	name = "magazine (Compressed Biomatter)"
	desc = "An advanced matter compression unit, used to feed biomass into a Rapid On-board Fabricator. Accepts biomass globules."

	icon = 'icons/modules/projectiles/magazines/bio.dmi'
	icon_state = "bio-4"
	base_icon_state = "bio"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 4

	ammo_caliber = /datum/ammo_caliber/biomatter
	ammo_preload = /obj/item/ammo_casing/biomatter
	materials_base = list("flesh" = 1000)
	ammo_max = 10

/obj/item/ammo_magazine/biomatter/large
	icon_state = "bio-large-5"
	base_icon_state = "bio-large"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5

	ammo_max = 30

/obj/item/ammo_magazine/biomatter/large/banana
	icon_state = "banana-mag"
	base_icon_state = "banana-mag"
	rendering_system = GUN_RENDERING_DISABLED
