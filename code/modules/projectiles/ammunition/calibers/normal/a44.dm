/datum/ammo_caliber/a44
	id = "a44"
	caliber = ".44"

//* Casings

/obj/item/ammo_casing/a44
	desc = "A .44 bullet casing."
	casing_caliber = /datum/ammo_caliber/a44
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "large"
	projectile_type = /obj/projectile/bullet/pistol/strong
	materials_base = list(MAT_STEEL = 210)

/obj/item/ammo_casing/a44/rubber
	desc = "A .44 rubber bullet casing."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/pistol/rubber/strong
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a44/silver
	desc = "A .44 silver bullet casing."
	icon_state = "large-silver"
	projectile_type = /obj/projectile/bullet/pistol/strong/silver
	materials_base = list(MAT_STEEL = 170, MAT_SILVER = 90)

//* Magazines

/obj/item/ammo_magazine/a44
	ammo_caliber = /datum/ammo_caliber/a44

/obj/item/ammo_magazine/a44
	name = "magazine (.44)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "m44-7"
	base_icon_state = "m44"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 7
	materials_base = list(MAT_STEEL = 1260)
	ammo_preload = /obj/item/ammo_casing/a44
	ammo_max = 7

/obj/item/ammo_magazine/a44/empty
	icon_state = "m44-0"
	ammo_current = 0

/obj/item/ammo_magazine/a44/rubber
	name = "magazine (.44 rubber)"
	desc = "A magazine for .44 less-than-lethal ammo."
	ammo_preload = /obj/item/ammo_casing/a44/rubber

/obj/item/ammo_magazine/a44/silver
	name = "magazine (.44 silver)"
	icon_state = "m44ag-7"
	base_icon_state = "m44ag"
	ammo_preload = /obj/item/ammo_casing/a44/silver

/obj/item/ammo_magazine/a44/clip
	name = "ammo clip (.44)"
	desc = "A stripper clip for reloading .44 rounds into magazines."
	ammo_preload = /obj/item/ammo_casing/a44
	materials_base = list(MAT_STEEL = 1620) // metal costs are very roughly based around one .50 casing = 180 metal
	ammo_max = 9
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "pistol-9"
	base_icon_state = "pistol"
	magazine_type = MAGAZINE_TYPE_CLIP
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 9

/obj/item/ammo_magazine/a44/speedloader
	name = "speedloader (.44)"
	ammo_preload = /obj/item/ammo_casing/a44
	materials_base = list(MAT_STEEL = 250)
	ammo_max = 6
	magazine_type = MAGAZINE_TYPE_SPEEDLOADER
	icon = 'icons/modules/projectiles/magazines/old_speedloader_6.dmi'
	icon_state = "normal-6"
	base_icon_state = "normal"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 6

/obj/item/ammo_magazine/a44/speedloader/empty
	ammo_current = 0

/obj/item/ammo_magazine/a44/speedloader/rubber
	name = "speedloader (.44 rubber)"
	icon_state = "blue-6"
	base_icon_state = "blue"
	ammo_preload = /obj/item/ammo_casing/a44/rubber

/obj/item/ammo_magazine/a44/speedloader/silver
	name = "speedloader (.44 silver)"
	icon_state = "holy-6"
	base_icon_state = "holy"
	ammo_preload = /obj/item/ammo_casing/a44/silver
