/datum/caliber/a357
	caliber = ".357"
	diameter = 9.1
	length = 40

//* Casings

/obj/item/ammo_casing/a357
	name = "bullet casing (.357)"
	desc = "A .357 bullet casing."
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "large"
	base_icon_state = "large"
	projectile_type = /obj/projectile/bullet/pistol/strong
	materials_base = list(MAT_STEEL = 210)
	regex_this_caliber = /datum/caliber/a357

/obj/item/ammo_casing/a357/silver
	desc = "A .357 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "large-white"
	base_icon_state = "large-white"
	materials_base = list(MAT_STEEL = 350, MAT_SILVER = 200)

/obj/item/ammo_casing/a357/stun
	desc = "A .357 stun bullet casing."
	icon_state = "large-red"
	base_icon_state = "large-red"
	projectile_type = /obj/projectile/energy/electrode/stunshot/strong

/obj/item/ammo_casing/a357/rubber
	desc = "A .357 rubber bullet casing."
	icon_state = "large-blue"
	base_icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/pistol/rubber/strong

/obj/item/ammo_casing/a357/flash
	desc = "A .357 flash bullet casing."
	icon_state = "large-white"
	base_icon_state = "large-white"
	projectile_type = /obj/projectile/energy/flash/strong

//* Magazines - Speedloaders

#warn a357/
/obj/item/ammo_magazine/s357
	name = "speedloader (.357)"
	desc = "A speedloader for .357 revolvers."
	icon = 'icons/modules/projectiles/magazines/old_speedloader_6.dmi'
	icon_state = "normal-6"
	base_icon_state = "normal"
	ammo_caliber = /datum/caliber/a357
	ammo_preload = /obj/item/ammo_casing/a357
	ammo_type = /obj/item/ammo_casing/a357
	ammo_max = 6
	materials_base = list(MAT_STEEL = 500)

/obj/item/ammo_magazine/s357/silver
	name = "speedloader (.357 silver)"
	icon_state = "holy-6"
	base_icon_state = "holy"
	ammo_preload = /obj/item/ammo_casing/a357/silver
	ammo_type = /obj/item/ammo_casing/a357/silver

/obj/item/ammo_magazine/s357/stun
	name = "speedloader (.357 stun)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "redtip-6"
	base_icon_state = "redtip"
	ammo_preload = /obj/item/ammo_casing/a357/stun
	ammo_type = /obj/item/ammo_casing/a357/stun

/obj/item/ammo_magazine/s357/rubber
	name = "speedloader (.357 rubber)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "bluetip-6"
	base_icon_state = "bluetip"
	ammo_preload = /obj/item/ammo_casing/a357/rubber
	ammo_type = /obj/item/ammo_casing/a357/rubber

/obj/item/ammo_magazine/s357/flash
	name = "speedloader (.357 flash)"
	desc = "A speedloader for .357 revolvers."
	icon_state = "white-6"
	base_icon_state = "white"
	ammo_preload = /obj/item/ammo_casing/a357/flash
	ammo_type = /obj/item/ammo_casing/a357/flash
