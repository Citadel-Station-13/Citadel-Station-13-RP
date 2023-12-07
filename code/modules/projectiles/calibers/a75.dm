/**
 * oh god oh fuck-
 */
/datum/caliber/a75
	caliber = ".75"

/obj/item/ammo_casing/a75
	desc = "A .75 gyrojet rocket sheathe."
	icon = 'icons/modules/projectiles/casings/misc.dmi'
	icon_state = "shell"
	regex_this_caliber = /datum/caliber/a75
	projectile_type = /obj/projectile/bullet/gyro
	materials_base = list(MAT_STEEL = 2000)

#warn a75/
/obj/item/ammo_magazine/m75
	name = "magazine (.75 Gyrojet)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "m75-1"
	base_icon_state = "m75"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_caliber = /datum/caliber/a75
	ammo_preload = /obj/item/ammo_casing/a75
	ammo_max = 8

/obj/item/ammo_magazine/m75/empty
	icon_state = "m75-0"
	ammo_current = 0
