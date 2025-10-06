/datum/ammo_caliber/biomatter/wax
	id = "wax"
	caliber = "wax"

/obj/item/ammo_casing/biomatter/wax
	name = "wax globule"
	desc = "Tacky wax rendered semi-solid and ready for compression."
	icon_state = "globule"
	color = "#E6E685"
	projectile_type = /obj/projectile/bullet/organic/wax
	casing_caliber = /datum/ammo_caliber/biomatter/wax
	materials_base = list(
		/datum/prototype/material/wax::id = 100,
	)

/obj/item/ammo_magazine/biovial
	name = "bio-vial (Liquid Wax)"
	desc = "Biological Munitions Vials, commonly referred to as bio-vials, contain liquid biomatter of some form, for use in exotic weapons systems. This one accepts wax globules."

	icon = 'icons/modules/projectiles/magazines/bio.dmi'
	icon_state = "vial-4"
	base_icon_state = "vial"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 4

	ammo_caliber = /datum/ammo_caliber/biomatter/wax
	ammo_preload = /obj/item/ammo_casing/biomatter/wax
	materials_base = list(
		/datum/prototype/material/wax::id = 100,
	)
	ammo_max = 10
