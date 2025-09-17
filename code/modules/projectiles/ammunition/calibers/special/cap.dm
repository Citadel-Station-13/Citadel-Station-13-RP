/datum/ammo_caliber/cap_gun
	id = "cap_gun"
	caliber = "cap_gun"

/obj/item/ammo_casing/cap_gun
	name = "cap"
	desc = "A cap for children toys."
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	casing_caliber = /datum/ammo_caliber/cap_gun
	color = "#FF0000"
	projectile_type = /obj/projectile/bullet/pistol/cap
	materials_base = list(MAT_STEEL = 85)

/obj/item/ammo_magazine/cap_gun
	name = "speedloader (caps)"
	icon = 'icons/modules/projectiles/magazines/old_speedloader_7.dmi'
	icon_state = "normal-7"
	base_icon_state = "normal"
	rendering_system = GUN_RENDERING_STATES
	ammo_caliber = /datum/ammo_caliber/cap_gun
	ammo_preload = /obj/item/ammo_casing/cap_gun
	materials_base = list(MAT_STEEL = 50)
	ammo_max = 7

