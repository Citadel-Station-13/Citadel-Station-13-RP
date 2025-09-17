/**
 * oh god oh fuck-
 */
/datum/ammo_caliber/a75
	id = "a75"
	caliber = ".75"

/obj/item/ammo_casing/a75
	desc = "A .75 gyrojet rocket sheathe."
	icon = 'icons/modules/projectiles/casings/misc.dmi'
	icon_state = "shell"
	casing_caliber = /datum/ammo_caliber/a75
	projectile_type = /obj/projectile/bullet/gyro
	materials_base = list(MAT_STEEL = 2000)

/obj/item/ammo_magazine/a75
	name = "magazine (.75 Gyrojet)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "m75-1"
	base_icon_state = "m75"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_caliber = /datum/ammo_caliber/a75
	ammo_preload = /obj/item/ammo_casing/a75
	ammo_max = 8

/obj/item/ammo_magazine/a75/empty
	icon_state = "m75-0"
	ammo_current = 0

/obj/item/ammo_magazine/a75/rifle
	ammo_max = 30

/obj/item/ammo_magazine/a75/rifle/empty
	icon_state = "m75-0"
	ammo_current = 0

/obj/item/ammo_magazine/a75/box
	name = "box magazine (.75 Gyrojet)"

	icon = 'icons/modules/projectiles/magazines/old_magazine_box.dmi'
	icon_state = "m75-1"
	base_icon_state = "m75"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	ammo_max = 50

/obj/item/ammo_magazine/a75/box/empty
	icon_state = "m75-0"

	ammo_current = 0
