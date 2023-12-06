/**
 * oh god oh fuck-
 */
/datum/caliber/a75
	caliber = ".75"

/obj/item/ammo_casing/a75
	desc = "A .75 gyrojet rocket sheathe."
	caliber = ".75"
	projectile_type = /obj/projectile/bullet/gyro
	materials_base = list(MAT_STEEL = 4000)

/obj/item/ammo_magazine/m75
	name = "magazine (.75 Gyrojet)"
	icon_state = "m75"
	mag_type = MAGAZINE
	caliber = ".75"
	ammo_preload = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	ammo_max = 8

/obj/item/ammo_magazine/m75/empty
	ammo_current = 0
