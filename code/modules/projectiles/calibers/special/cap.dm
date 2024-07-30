/datum/caliber/cap_gun
	caliber = "capgun"

#warn cap_gun/
/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	regex_this_caliber = /datum/caliber/cap_gun
	color = "#FF0000"
	projectile_type = /obj/projectile/bullet/pistol/cap
	materials_base = list(MAT_STEEL = 85)

#warn cap_gun/
/obj/item/ammo_magazine/caps
	name = "speedloader (caps)"
	icon = 'icons/modules/projectiles/magazines/old_speedloader_7.dmi'
	icon_state = "normal-7"
	base_icon_state = "normal"
	rendering_system = GUN_RENDERING_STATES
	ammo_caliber = /datum/caliber/cap_gun
	ammo_preload = /obj/item/ammo_casing/cap
	materials_base = list(MAT_STEEL = 50)
	ammo_max = 7

