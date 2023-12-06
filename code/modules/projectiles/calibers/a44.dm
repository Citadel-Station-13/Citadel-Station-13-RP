/datum/caliber/a44
	caliber = ".44"

/obj/item/ammo_magazine/m44
	name = "magazine (.44)"
	icon_state = "m44"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = ".44"
	materials_base = list(MAT_STEEL = 1260)
	ammo_preload = /obj/item/ammo_casing/a44
	ammo_max = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/m44/empty
	ammo_current = 0

/obj/item/ammo_magazine/clip/c44
	name = "ammo clip (.44)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .44 rounds into magazines."
	caliber = ".44"
	ammo_preload = /obj/item/ammo_casing/a44
	materials_base = list(MAT_STEEL = 1620) // metal costs are very roughly based around one .50 casing = 180 metal
	ammo_max = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/s44
	name = "speedloader (.44)"
	icon_state = "44"
	icon = 'icons/obj/ammo.dmi'
	ammo_preload = /obj/item/ammo_casing/a44
	materials_base = list(MAT_STEEL = 1260) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".44"
	ammo_max = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/s44/empty
	ammo_current = 0

/obj/item/ammo_magazine/s44/rubber
	name = "speedloader (.44 rubber)"
	icon_state = "R44"
	ammo_preload = /obj/item/ammo_casing/a44/rubber

/obj/item/ammo_magazine/s44/silver
	name = "speedloader (.44 silver)"
	icon_state = "ag44"
	ammo_preload = /obj/item/ammo_casing/a44/silver
	materials_base = list(MAT_STEEL = 2100, MAT_SILVER = 1200)


/obj/item/ammo_casing/a44
	desc = "A .44 bullet casing."
	caliber = ".44"
	projectile_type = /obj/projectile/bullet/pistol/strong
	materials_base = list(MAT_STEEL = 210)

/obj/item/ammo_casing/a44/rubber
	icon_state = "r-casing"
	desc = "A .44 rubber bullet casing."
	projectile_type = /obj/projectile/bullet/pistol/rubber/strong
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a44/silver
	desc = "A .44 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "ag_casing"
	projectile_type = /obj/projectile/bullet/pistol/strong/silver
	materials_base = list(MAT_STEEL = 350, MAT_SILVER = 200)
