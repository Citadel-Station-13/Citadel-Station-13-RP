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

/obj/item/ammo_magazine/m45
	name = "pistol magazine (.45)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	ammo_max = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/m45/empty
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

/obj/item/ammo_magazine/box/emp/b45
	name = "ammunition box (.45 haywire)"
	ammo_preload = /obj/item/ammo_casing/a45/emp

/obj/item/ammo_magazine/m45uzi
	name = "stick magazine (.45)"
	icon_state = "uzi45"
	mag_type = MAGAZINE
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 1200)
	caliber = ".45"
	ammo_max = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/m45uzi/empty
	ammo_current = 0

/obj/item/ammo_magazine/m45uzi/wt274
	name = "double-stack magazine (.45)"
	icon_state = "wt274"
	mag_type = MAGAZINE
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 2400)
	caliber = ".45"
	ammo_max = 32
	multiple_sprites = 1

/obj/item/ammo_magazine/m45tommy
	name = "Tommy Gun magazine (.45)"
	icon_state = "tommy-mag"
	mag_type = MAGAZINE
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 1500)
	caliber = ".45"
	ammo_max = 20

/obj/item/ammo_magazine/m45tommy/ap
	name = "Tommy Gun magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/m45tommy/empty
	ammo_current = 0

/obj/item/ammo_magazine/m45tommydrum
	name = "Tommy Gun drum magazine (.45)"
	icon_state = "tommy-drum"
	w_class = ITEMSIZE_NORMAL // Bulky ammo doesn't fit in your pockets!
	mag_type = MAGAZINE
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 3750)
	caliber = ".45"
	ammo_max = 50

/obj/item/ammo_magazine/m45tommydrum/ap
	name = "Tommy Gun drum magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/m45tommydrum/empty
	ammo_current = 0

/obj/item/ammo_magazine/clip/c45
	name = "ammo clip (.45)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading .45 rounds into magazines."
	caliber = ".45"
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 675) // metal costs very roughly based around one .45 casing = 75 metal
	ammo_max = 9
	multiple_sprites = 1

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

/obj/item/ammo_magazine/s45
	name = "speedloader (.45)"
	icon_state = "45s"
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = ".45"
	ammo_max = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/s45/empty
	ammo_current = 0

/obj/item/ammo_magazine/s45/rubber
	name = "speedloader (.45 rubber)"
	ammo_preload = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/s45/practice
	name = "speedloader (.45 practice)"
	ammo_preload = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/s45/flash
	name = "speedloader (.45 flash)"
	ammo_preload = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/s45/ap
	name = "speedloader (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/s45/silver
	name = "speedloader (.45 silver)"
	icon_state = "ag45s"
	ammo_preload = /obj/item/ammo_casing/a45/silver
	materials_base = list(MAT_STEEL = 780, MAT_SILVER = 600)
