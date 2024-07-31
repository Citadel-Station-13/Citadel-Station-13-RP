/datum/caliber/a38
	caliber = ".38"

/obj/item/ammo_casing/a38
	desc = "A .38 bullet casing."
	regex_this_caliber = /datum/caliber/a38
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	projectile_type = /obj/projectile/bullet/pistol
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a38/rubber
	desc = "A .38 rubber bullet casing."
	icon_state = "small-reinf"
	projectile_type = /obj/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a38/emp
	name = ".38 haywire round"
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "small-tech"
	projectile_type = /obj/projectile/ion/small
	materials_base = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a38/silver
	desc = "A .38 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "small-silver"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials_base = list(MAT_STEEL = 130, MAT_SILVER = 100)

/obj/item/ammo_magazine/s38/speedloader
	name = "speedloader (.38)"
	desc = "A speedloader for .38 revolvers."
	icon = 'icons/modules/projectiles/magazines/old_speedloader_6.dmi'
	icon_state = "normal-6"
	base_icon_state = "normal"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 6
	ammo_caliber = /datum/caliber/a38
	materials_base = list(MAT_STEEL = 360)
	ammo_preload = /obj/item/ammo_casing/a38
	ammo_max = 6

/obj/item/ammo_magazine/s38/speedloader/rubber
	name = "speedloader (.38 rubber)"
	icon_state = "blue-6"
	base_icon_state = "blue"
	ammo_preload = /obj/item/ammo_casing/a38/rubber

/obj/item/ammo_magazine/s38/speedloader/emp
	name = "speedloader (.38 haywire)"
	icon_state = "bluetip-6"
	base_icon_state = "bluetip"
	ammo_preload = /obj/item/ammo_casing/a38/emp

/obj/item/ammo_magazine/s38/speedloader/silver
	name = "speedloader (.38 silver)"
	icon_state = "holy-6"
	base_icon_state = "holy"
	ammo_preload = /obj/item/ammo_casing/a38/silver
	materials_base = list(MAT_STEEL = 780, MAT_SILVER = 600)
