/datum/caliber/cap
	caliber = "capgun"

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	icon_state = "r-casing"
	color = "#FF0000"
	projectile_type = /obj/projectile/bullet/pistol/cap
	materials_base = list(MAT_STEEL = 85)

/obj/item/ammo_magazine/caps
	name = "speedloader (caps)"
	icon_state = "T38"
	caliber = "caps"
	color = "#FF0000"
	ammo_preload = /obj/item/ammo_casing/cap
	materials_base = list(MAT_STEEL = 600)
	ammo_max = 7
	multiple_sprites = 1

