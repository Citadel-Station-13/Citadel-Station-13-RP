/datum/caliber/a38
	caliber = ".38"

/obj/item/ammo_casing/a38
	desc = "A .38 bullet casing."
	caliber = ".38"
	projectile_type = /obj/projectile/bullet/pistol
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a38/rubber
	desc = "A .38 rubber bullet casing."
	icon_state = "r-casing"
	projectile_type = /obj/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/a38/emp
	name = ".38 haywire round"
	desc = "A .38 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "empcasing"
	projectile_type = /obj/projectile/ion/small
	materials_base = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a38/silver
	desc = "A .38 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "ag-casing"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials_base = list(MAT_STEEL = 130, MAT_SILVER = 100)

/obj/item/ammo_magazine/s38
	name = "speedloader (.38)"
	desc = "A speedloader for .38 revolvers."
	icon_state = "38"
	caliber = ".38"
	materials_base = list(MAT_STEEL = 360)
	ammo_preload = /obj/item/ammo_casing/a38
	ammo_max = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s38/rubber
	name = "speedloader (.38 rubber)"
	icon_state = "T38"
	ammo_preload = /obj/item/ammo_casing/a38/rubber

/obj/item/ammo_magazine/s38/emp
	name = "speedloader (.38 haywire)"
	ammo_preload = /obj/item/ammo_casing/a38/emp

/obj/item/ammo_magazine/s38/silver
	name = "speedloader (.38 silver)"
	icon_state = "ag_38"
	ammo_preload = /obj/item/ammo_casing/a38/silver
	materials_base = list(MAT_STEEL = 780, MAT_SILVER = 600)
