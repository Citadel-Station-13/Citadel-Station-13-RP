/datum/ammo_caliber/a38
	id = "a38"
	caliber = ".38"

/obj/item/ammo_casing/a38
	desc = "A .38 bullet casing."
	casing_caliber = /datum/ammo_caliber/a38
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	projectile_type = /obj/projectile/bullet/pistol
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a38/rubber
	desc = "A .38 rubber bullet casing."
	icon_state = "small-reinf"
	projectile_type = /obj/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a38/emp
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "small-tech"
	projectile_type = /obj/projectile/ion/small
	materials_base = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a38/silver
	desc = "A .38 silver bullet casing."
	icon_state = "small-silver"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials_base = list(MAT_STEEL = 40, MAT_SILVER = 30)
//* Magazines *//

/obj/item/ammo_magazine/a38
	name = "magazine (.38)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "9x19-small"
	base_icon_state = "9x19-small"
	origin_tech = list(TECH_COMBAT = 2)
	materials_base = list(MAT_STEEL = 480)
	ammo_caliber = /datum/ammo_caliber/a38
	ammo_preload = /obj/item/ammo_casing/a38
	ammo_max = 8
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/a38/speedloader
	name = "speedloader (.38)"
	desc = "A speedloader for .38 revolvers."
	icon = 'icons/modules/projectiles/magazines/old_speedloader_6.dmi'
	icon_state = "normal-6"
	base_icon_state = "normal"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 6
	magazine_type = MAGAZINE_TYPE_SPEEDLOADER
	materials_base = list(MAT_STEEL = 360)
	ammo_preload = /obj/item/ammo_casing/a38
	ammo_max = 6

/obj/item/ammo_magazine/a38/speedloader/rubber
	name = "speedloader (.38 rubber)"
	icon_state = "blue-6"
	base_icon_state = "blue"
	ammo_preload = /obj/item/ammo_casing/a38/rubber

/obj/item/ammo_magazine/a38/speedloader/emp
	name = "speedloader (.38 haywire)"
	icon_state = "tech-6"
	base_icon_state = "tech"
	ammo_preload = /obj/item/ammo_casing/a38/emp

/obj/item/ammo_magazine/a38/speedloader/silver
	name = "speedloader (.38 silver)"
	icon_state = "holy-6"
	base_icon_state = "holy"
	ammo_preload = /obj/item/ammo_casing/a38/silver
