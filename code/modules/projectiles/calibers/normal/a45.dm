/datum/caliber/a45
	caliber = ".45"

//* Casings

/obj/item/ammo_casing/a45
	desc = "A .45 bullet casing."
	regex_this_caliber = /datum/caliber/a45
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "large"
	projectile_type = /obj/projectile/bullet/pistol/medium
	materials_base = list(MAT_STEEL = 75)

/obj/item/ammo_casing/a45/ap
	desc = "A .45 Armor-Piercing bullet casing."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/pistol/medium/ap

/obj/item/ammo_casing/a45/hunter
	desc = "A .45 hunting bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/pistol/medium/hunter

/obj/item/ammo_casing/a45/practice
	desc = "A .45 practice bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/practice
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/rubber
	desc = "A .45 rubber bullet casing."
	icon_state = "large-red"
	projectile_type = /obj/projectile/bullet/pistol/rubber
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/flash
	desc = "A .45 flash shell casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/energy/flash
	materials_base = list(MAT_STEEL = 60)

/obj/item/ammo_casing/a45/emp
	name = ".45 haywire round"
	desc = "A .45 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/ion/small
	materials_base = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a45/hp
	desc = "A .45 hollow-point bullet casing."
	icon_state = "large-red"
	projectile_type = /obj/projectile/bullet/pistol/medium/hp

/obj/item/ammo_casing/a45/silver
	name = ".45 silver round"
	desc = "A .45 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials_base = list(MAT_STEEL = 130, MAT_SILVER = 100)


//* Magazines

/obj/item/ammo_magazine/a45
	ammo_caliber = /datum/caliber/a45

#warn a45/
/obj/item/ammo_magazine/m45
	name = "pistol magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "45-7"
	base_icon_state = "45"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 7
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 250)
	ammo_max = 7

/obj/item/ammo_magazine/m45/empty
	icon_state = "45-0"
	ammo_current = 0

/obj/item/ammo_magazine/m45/hunter
	name = "magazine (.45 hunter)"
	ammo_preload = /obj/item/ammo_casing/a45/hunter

/obj/item/ammo_magazine/m45/rubber
	name = "magazine (.45 rubber)"
	ammo_preload = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/m45/practice
	name = "magazine (.45 practice)"
	ammo_preload = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/m45/flash
	name = "magazine (.45 flash)"
	ammo_preload = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/m45/ap
	name = "magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

#warn what the fuck is this
/obj/item/ammo_magazine/box/emp/b45
	name = "ammunition box (.45 haywire)"
	ammo_preload = /obj/item/ammo_casing/a45/emp

#warn a45/
/obj/item/ammo_magazine/m45uzi
	name = "stick magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "uzi45-8"
	base_icon_state = "uzi45"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 8
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 1200)
	ammo_max = 16

/obj/item/ammo_magazine/m45uzi/empty
	icon_state = "uzi45-0"
	ammo_current = 0

#warn a45/
/obj/item/ammo_magazine/wt274
	name = "double-stack magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "wt-274-1"
	base_icon_state = "wt274"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 500)
	ammo_max = 32

#warn a45/
/obj/item/ammo_magazine/m45tommy
	name = "Tommy Gun magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "tommy-mag"
	rendering_system = GUN_RENDERING_DISABLED
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 350)
	ammo_max = 20

/obj/item/ammo_magazine/m45tommy/ap
	name = "Tommy Gun magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/m45tommy/empty
	ammo_current = 0

#warn a45/
/obj/item/ammo_magazine/m45tommydrum
	name = "Tommy Gun drum magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_drum.dmi'
	icon_state = "tommy-drum"
	rendering_system = GUN_RENDERING_DISABLED
	w_class = WEIGHT_CLASS_NORMAL
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 500)
	ammo_max = 50

/obj/item/ammo_magazine/m45tommydrum/ap
	name = "Tommy Gun drum magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/m45tommydrum/empty
	ammo_current = 0

#warn a45/
/obj/item/ammo_magazine/clip/c45
	name = "ammo clip (.45)"
	desc = "A stripper clip for reloading .45 rounds into magazines."
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "pistol-9"
	base_icon_state = "pistol"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 9
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 250)
	ammo_max = 9

/obj/item/ammo_magazine/clip/c45/rubber
	name = "ammo clip (.45 rubber)"
	ammo_preload = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/clip/c45/hunter
	name = "ammo clip (.45 hunter)"
	ammo_preload = /obj/item/ammo_casing/a45/hunter

/obj/item/ammo_magazine/clip/c45/practice
	name = "ammo clip (.45 practice)"
	ammo_preload = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/clip/c45/flash
	name = "ammo clip (.45 flash)"
	ammo_preload = /obj/item/ammo_casing/a45/flash

#warn a45/
/obj/item/ammo_magazine/s45
	name = "speedloader (.45)"
	icon = 'icons/modules/projectiles/magazines/old_speedloader_7.dmi'
	icon_state = "normal-7"
	base_icon_state = "normal"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 7
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 250)
	ammo_max = 7

/obj/item/ammo_magazine/s45/empty
	ammo_current = 0

/obj/item/ammo_magazine/s45/rubber
	name = "speedloader (.45 rubber)"
	icon_state = "bluetip-7"
	base_icon_state = "bluetip"
	ammo_preload = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/s45/practice
	name = "speedloader (.45 practice)"
	ammo_preload = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/s45/flash
	name = "speedloader (.45 flash)"
	icon_state = "bluetip-7"
	base_icon_state = "bluetip"
	ammo_preload = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/s45/ap
	name = "speedloader (.45 AP)"
	icon_state = "bluetip-7"
	base_icon_state = "bluetip"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/s45/silver
	name = "speedloader (.45 silver)"
	icon_state = "holy-7"
	base_icon_state = "holy"
	ammo_preload = /obj/item/ammo_casing/a45/silver
