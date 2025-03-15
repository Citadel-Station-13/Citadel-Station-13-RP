/datum/ammo_caliber/a357
	id = "a357"
	caliber = ".357"
	diameter = 9.1
	length = 40

//* Casings

/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	casing_caliber = /datum/ammo_caliber/a357
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "large"
	projectile_type = /obj/projectile/bullet/pistol/strong
	materials_base = list(MAT_STEEL = 210)

/obj/item/ammo_casing/a357/silver
	desc = "A .357 silver bullet casing."
	icon_state = "large-silver"
	projectile_type = /obj/projectile/bullet/pistol/strong/silver
	materials_base = list(MAT_STEEL = 170, MAT_SILVER = 80)

/obj/item/ammo_casing/a357/stun
	desc = "A .357 stun bullet casing."
	icon_state = "large-red"
	projectile_type = /obj/projectile/energy/electrode/stunshot/strong

/obj/item/ammo_casing/a357/rubber
	desc = "A .357 rubber bullet casing."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/pistol/rubber/strong

/obj/item/ammo_casing/a357/flash
	desc = "A .357 flash bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/energy/flash/strong

//* Magazines - Speedloaders

/obj/item/ammo_magazine/a357/speedloader
	name = "speedloader (.357)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/modules/projectiles/magazines/old_speedloader_6.dmi'
	icon_state = "normal-6"
	base_icon_state = "normal"
	ammo_caliber = /datum/ammo_caliber/a357
	ammo_preload = /obj/item/ammo_casing/a357
	magazine_type = MAGAZINE_TYPE_SPEEDLOADER
	ammo_max = 6
	rendering_count = 6
	rendering_system = GUN_RENDERING_STATES
	materials_base = list(MAT_STEEL = 500)

/obj/item/ammo_magazine/a357/speedloader/silver
	name = "speedloader (.357 silver)"
	icon_state = "holy-6"
	base_icon_state = "holy"
	ammo_preload = /obj/item/ammo_casing/a357/silver

/obj/item/ammo_magazine/a357/speedloader/stun
	name = "speedloader (.357 stun)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "redtip-6"
	base_icon_state = "redtip"
	ammo_preload = /obj/item/ammo_casing/a357/stun

/obj/item/ammo_magazine/a357/speedloader/rubber
	name = "speedloader (.357 rubber)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "bluetip-6"
	base_icon_state = "bluetip"
	ammo_preload = /obj/item/ammo_casing/a357/rubber

/obj/item/ammo_magazine/a357/speedloader/flash
	name = "speedloader (.357 flash)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "white-6"
	base_icon_state = "white"
	ammo_preload = /obj/item/ammo_casing/a357/flash
