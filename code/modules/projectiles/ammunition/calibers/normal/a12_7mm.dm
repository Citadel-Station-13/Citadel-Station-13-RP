/datum/ammo_caliber/a12_7mm
	caliber = "12.7mm"

/obj/item/ammo_casing/a127
	desc = "A 12.7mm shell."
	icon = 'icons/modules/projectiles/casings/12_7mm.dmi'
	icon_state = "lcasing"
	regex_this_caliber = /datum/ammo_caliber/a12_7mm
	projectile_type = /obj/projectile/bullet/rifle/a127
	materials_base = list(MAT_STEEL = 1250)

/obj/item/ammo_magazine/mfiftycalcaseless
	name = "Wild Hunt magazine (12.7mm caseless)"
	icon_state = "caseless-127"
	ammo_caliber = /datum/ammo_caliber/a12_7mm
	ammo_max = 20
	ammo_type = /obj/item/ammo_casing/fiftycalcaseless
	multiple_sprites = 1

/obj/item/ammo_casing/fiftycalcaseless
	name = "caseless phoron round"
	desc = "A 12.7mm caseless round."
	regex_this_caliber = /datum/ammo_caliber/a12_7mm
	icon_state = "p-casing"
	projectile_type = /obj/projectile/bullet/incendiary/caseless
	casing_flags = CASING_DELETE
