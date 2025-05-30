/datum/ammo_caliber/a5mm
	id = "a5mm"
	caliber = "5mm"
	diameter = 5

//* Magazines *//

/obj/item/ammo_magazine/m5mmcaseless
	name = "prototype rifle magazine (5mm caseless)"
	icon_state = "caseless-mag-0"
	base_icon_state = "caseless-mag"
	ammo_preload = /obj/item/ammo_casing/a5mmcaseless
	ammo_caliber = /datum/ammo_caliber/a5mm
	ammo_max = 30
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/m5mmcaseless/stun
	icon_state = "caseless-mag-alt-0"
	base_icon_state = "caseless-mag-alt"
	ammo_preload = /obj/item/ammo_casing/a5mmcaseless/stun

//* Ammunition *//

/obj/item/ammo_casing/a5mmcaseless
	desc = "A 5mm solid phoron caseless round."
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	icon_spent = TRUE
	casing_caliber = /datum/ammo_caliber/a5mm
	projectile_type = /obj/projectile/bullet/pistol // Close enough to be comparable.
	materials_base = list(MAT_STEEL = 180)
	casing_flags = CASING_DELETE

/obj/item/ammo_casing/a5mmcaseless/stun
	desc = "A 5mm solid phoron caseless stun round."
	projectile_type = /obj/projectile/energy/electrode // Maybe nerf this considering there's 30 rounds in a mag.
