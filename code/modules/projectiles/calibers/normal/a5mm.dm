/datum/caliber/a5mm
	caliber = "5mm"
	diameter = 5

//* Magazines *//

/obj/item/ammo_magazine/m5mmcaseless
	name = "prototype rifle magazine (5mm caseless)"
	icon_state = "caseless-mag"
	ammo_type = /obj/item/ammo_casing/a5mmcaseless
	ammo_caliber = /datum/caliber/a5_mm
	ammo_max = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/m5mmcaseless/stun
	icon_state = "caseless-mag-alt"
	ammo_type = /obj/item/ammo_casing/a5mmcaseless/stun

//* Ammunition *//

/obj/item/ammo_casing/a5mmcaseless
	desc = "A 5mm solid phoron caseless round."
	icon_state = "p-casing"
	regex_this_caliber = /datum/caliber/a5_mm
	projectile_type = /obj/projectile/bullet/pistol // Close enough to be comparable.
	materials_base = list(MAT_STEEL = 180)
	casing_flags = CASING_DELETE

/obj/item/ammo_casing/a5mmcaseless/stun
	desc = "A 5mm solid phoron caseless stun round."
	projectile_type = /obj/projectile/energy/electrode // Maybe nerf this considering there's 30 rounds in a mag.
