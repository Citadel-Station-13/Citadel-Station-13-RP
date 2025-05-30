/datum/ammo_caliber/a45
	id = "a45"
	caliber = ".45"

//* Casings

/obj/item/ammo_casing/a45
	desc = "A .45 bullet casing."
	casing_caliber = /datum/ammo_caliber/a45
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
	desc = "A .45 bullet casing fitted with a single-use ion pulse generator."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/ion/small
	materials_base = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_casing/a45/hp
	desc = "A .45 hollow-point bullet casing."
	icon_state = "large-red"
	projectile_type = /obj/projectile/bullet/pistol/medium/hp

/obj/item/ammo_casing/a45/silver
	desc = "A .45 silver bullet casing."
	icon_state = "large-silver"
	projectile_type = /obj/projectile/bullet/pistol/silver
	materials_base = list(MAT_STEEL = 60, MAT_SILVER = 50)


//* Magazines

/obj/item/ammo_magazine/a45
	ammo_caliber = /datum/ammo_caliber/a45
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	rendering_system = GUN_RENDERING_STATES
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 250)

/obj/item/ammo_magazine/a45/doublestack
	name = "double-stack magazine (.45)"
	icon_state = "45-4"
	base_icon_state = "45"
	rendering_count = 4
	ammo_max = 12

/obj/item/ammo_magazine/a45/doublestack/empty
	icon_state = "45-0"
	ammo_current = 0

/obj/item/ammo_magazine/a45/doublestack/hunter
	name = "double-stack magazine (.45 hunter)"
	ammo_preload = /obj/item/ammo_casing/a45/hunter

/obj/item/ammo_magazine/a45/doublestack/rubber
	name = "double-stack magazine (.45 rubber)"
	ammo_preload = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/a45/doublestack/practice
	name = "double-stack magazine (.45 practice)"
	ammo_preload = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/a45/doublestack/flash
	name = "double-stack magazine (.45 flash)"
	ammo_preload = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/a45/doublestack/ap
	name = "double-stack magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/a45/doublestack/silver
	name = "double-stack magazine (.45 silver)"
	icon_state = "45ag-4"
	base_icon_state = "45ag"
	ammo_preload = /obj/item/ammo_casing/a45/silver

/obj/item/ammo_magazine/a45/singlestack
	ammo_caliber = /datum/ammo_caliber/a45
	name = "single-stack magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "colt45-7"
	base_icon_state = "colt45"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 7
	ammo_max = 7

/obj/item/ammo_magazine/a45/singlestack/empty
	icon_state = "colt45-0"
	ammo_current = 0

/obj/item/ammo_magazine/a45/singlestack/hunter
	name = "single-stack magazine (.45 hunter)"
	ammo_preload = /obj/item/ammo_casing/a45/hunter

/obj/item/ammo_magazine/a45/singlestack/rubber
	name = "single-stack magazine (.45 rubber)"
	ammo_preload = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/a45/singlestack/practice
	name = "single-stack magazine (.45 practice)"
	ammo_preload = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/a45/singlestack/flash
	name = "single-stack magazine (.45 flash)"
	ammo_preload = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/a45/singlestack/ap
	name = "single-stack magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/a45/singlestack/silver
	name = "single-stack magazine (.45 silver)"
	icon_state = "colt45ag-7"
	base_icon_state = "colt45ag"
	ammo_preload = /obj/item/ammo_casing/a45/silver

/obj/item/ammo_magazine/a45/uzi
	name = "stick magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "uzi45-8"
	base_icon_state = "uzi45"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 8
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 1200)
	ammo_max = 16

/obj/item/ammo_magazine/a45/uzi/empty
	icon_state = "uzi45-0"
	ammo_current = 0

/obj/item/ammo_magazine/a45/wt274
	name = "double-stack magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "wt-274-1"
	base_icon_state = "wt274"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 500)
	ammo_max = 32

/obj/item/ammo_magazine/a45/tommy
	name = "Tommy Gun magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "tommy-mag"
	rendering_system = GUN_RENDERING_DISABLED
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 350)
	ammo_max = 20

/obj/item/ammo_magazine/a45/tommy/ap
	name = "Tommy Gun magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/a45/tommy/empty
	ammo_current = 0

/obj/item/ammo_magazine/a45/tommy/drum
	name = "Tommy Gun drum magazine (.45)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_drum.dmi'
	icon_state = "tommy-drum"
	rendering_system = GUN_RENDERING_DISABLED
	w_class = WEIGHT_CLASS_NORMAL
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 500)
	ammo_max = 50

/obj/item/ammo_magazine/a45/tommy/drum/ap
	name = "Tommy Gun drum magazine (.45 AP)"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/a45/tommy/drum/empty
	ammo_current = 0

/obj/item/ammo_magazine/a45/clip
	name = "ammo clip (.45)"
	desc = "A stripper clip for reloading .45 rounds into magazines."
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "pistol-9"
	base_icon_state = "pistol"
	rendering_system = GUN_RENDERING_STATES
	magazine_type = MAGAZINE_TYPE_CLIP
	rendering_count = 9
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 250)
	ammo_max = 9

/obj/item/ammo_magazine/a45/clip/rubber
	name = "ammo clip (.45 rubber)"
	ammo_preload = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/a45/clip/hunter
	name = "ammo clip (.45 hunter)"
	ammo_preload = /obj/item/ammo_casing/a45/hunter

/obj/item/ammo_magazine/a45/clip/practice
	name = "ammo clip (.45 practice)"
	ammo_preload = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/a45/clip/flash
	name = "ammo clip (.45 flash)"
	ammo_preload = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/a45/speedloader
	name = "speedloader (.45)"
	icon = 'icons/modules/projectiles/magazines/old_speedloader_7.dmi'
	icon_state = "normal-7"
	base_icon_state = "normal"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 7
	ammo_preload = /obj/item/ammo_casing/a45
	materials_base = list(MAT_STEEL = 250)
	magazine_type = MAGAZINE_TYPE_SPEEDLOADER
	ammo_max = 7

/obj/item/ammo_magazine/a45/speedloader/empty
	ammo_current = 0

/obj/item/ammo_magazine/a45/speedloader/rubber
	name = "speedloader (.45 rubber)"
	icon_state = "redtip-7"
	base_icon_state = "redtip"
	ammo_preload = /obj/item/ammo_casing/a45/rubber

/obj/item/ammo_magazine/a45/speedloader/practice
	name = "speedloader (.45 practice)"
	icon_state = "whitetip-7"
	base_icon_state = "whitetip"
	ammo_preload = /obj/item/ammo_casing/a45/practice

/obj/item/ammo_magazine/a45/speedloader/flash
	name = "speedloader (.45 flash)"
	icon_state = "whitetip-7"
	base_icon_state = "whitetip"
	ammo_preload = /obj/item/ammo_casing/a45/flash

/obj/item/ammo_magazine/a45/speedloader/ap
	name = "speedloader (.45 AP)"
	icon_state = "bluetip-7"
	base_icon_state = "bluetip"
	ammo_preload = /obj/item/ammo_casing/a45/ap

/obj/item/ammo_magazine/a45/speedloader/silver
	name = "speedloader (.45 silver)"
	icon_state = "holy-7"
	base_icon_state = "holy"
	ammo_preload = /obj/item/ammo_casing/a45/silver
