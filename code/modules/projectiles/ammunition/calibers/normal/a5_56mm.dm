/datum/ammo_caliber/a5_56mm
	id = "a5_56mm"
	caliber = "5.56mm"

//* Casings

/obj/item/ammo_casing/a5_56mm
	desc = "A 5.56mm bullet casing."
	casing_caliber = /datum/ammo_caliber/a5_56mm
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "large"
	projectile_type = /obj/projectile/bullet/rifle/a556
	materials_base = list(MAT_STEEL = 180)

/obj/item/ammo_casing/a5_56mm/ap
	desc = "A 5.56mm armor-piercing bullet casing."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/rifle/a556/ap
	materials_base = list(MAT_STEEL = 270)

/obj/item/ammo_casing/a5_56mm/practice
	desc = "A 5.56mm practice bullet casing."
	icon_state = "large=white"
	projectile_type = /obj/projectile/bullet/practice
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a5_56mm/blank
	desc = "A blank 5.56mm bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/blank
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a5_56mm/hp
	icon_state = "large-red"
	desc = "A 5.56mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a556/hp

/obj/item/ammo_casing/a5_56mm/hunter
	icon_state = "large-white"
	desc = "A 5.56mm hunting bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a556/hunter

/obj/item/ammo_casing/a5_56mm/silver
	icon_state = "large-silver"
	desc = "A 5.56mm silver bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a556/silver

//* Magazines

/obj/item/ammo_magazine/a5_56mm
	name = "magazine (5.56mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "m556-1"
	base_icon_state = "m556"
	ammo_caliber = /datum/ammo_caliber/a5_56mm
	materials_base = list(MAT_STEEL = 1800)
	ammo_preload = /obj/item/ammo_casing/a5_56mm
	ammo_max = 20
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/a5_56mm/ext
	name = "extended magazine (5.56mm)"
	materials_base = list(MAT_STEEL = 2700)
	ammo_max = 30

/obj/item/ammo_magazine/a5_56mm/empty
	icon_state = "m556-0"
	ammo_current = 0

/obj/item/ammo_magazine/a5_56mm/ext/empty
	icon_state = "m556-0"
	ammo_current = 0

/obj/item/ammo_magazine/a5_56mm/practice
	name = "magazine (5.56mm practice)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/practice

/obj/item/ammo_magazine/a5_56mm/practice/ext
	name = "extended magazine (5.56mm practice)"
	ammo_max = 30

/obj/item/ammo_magazine/a5_56mm/ap
	name = "magazine (5.56mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/ap

/obj/item/ammo_magazine/a5_56mm/ap/ext
	name = "extended magazine (5.56mm armor-piercing)"
	ammo_max = 30

/obj/item/ammo_magazine/a5_56mm/hunter
	name = "magazine (5.56mm hunting)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/hunter

/obj/item/ammo_magazine/a5_56mm/hunter/ext
	name = "extended magazine (5.56mm hunting)"
	ammo_max = 30

/obj/item/ammo_magazine/a5_56mm/silver
	name = "magazine (5.56mm silver)"
	icon_state = "m556ag-1"
	base_icon_state = "m556ag"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/silver
	ammo_max = 20

/obj/item/ammo_magazine/a5_56mm/ext/silver
	name = "extended magazine (5.56mm silver)"
	icon_state = "m556ag-1"
	base_icon_state = "m556ag"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/silver
	ammo_max = 30

/obj/item/ammo_magazine/a5_56mm/small
	name = "reduced magazine (5.56mm)"
	icon_state = "m556-small-1"
	base_icon_state = "m556-small"
	materials_base = list(MAT_STEEL = 900)
	ammo_max = 10

/obj/item/ammo_magazine/a5_56mm/small/empty
	icon_state = "m556-small-0"
	ammo_current = 0

/obj/item/ammo_magazine/a5_56mm/small/practice
	name = "magazine (5.56mm practice)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/practice

/obj/item/ammo_magazine/a5_56mm/small/ap
	name = "magazine (5.56mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/ap

/obj/item/ammo_magazine/a5_56mm/small/hunter
	name = "magazine (5.56mm hunting)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/hunter

/obj/item/ammo_magazine/a5_56mm/clip
	name = "ammo clip (5.56mm)"
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "rifle-5"
	base_icon_state = "rifle"
	ammo_caliber = /datum/ammo_caliber/a5_56mm
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5
	magazine_type = MAGAZINE_TYPE_CLIP
	ammo_preload = /obj/item/ammo_casing/a5_56mm
	materials_base = list(MAT_STEEL = 450) // metal costs are very roughly based around one 10mm casing = 180 metal
	ammo_max = 5

/obj/item/ammo_magazine/a5_56mm/clip/ap
	name = "rifle clip (5.56mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/ap

/obj/item/ammo_magazine/a5_56mm/clip/hunter
	name = "rifle clip (5.56mm hunting)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/hunter

/obj/item/ammo_magazine/a5_56mm/clip/practice
	name = "rifle clip (5.56mm practice)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm

/obj/item/ammo_magazine/a5_56mm/saw
	name = "magazine box (5.56mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_box.dmi'
	icon_state = "a556-5"
	base_icon_state = "a556"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5
	ammo_caliber = /datum/ammo_caliber/a5_56mm
	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a5_56mm
	w_class = WEIGHT_CLASS_NORMAL // This should NOT fit in your pocket!!
	ammo_max = 50

/obj/item/ammo_magazine/a5_56mm/saw/ap
	name = "magazine box (5.56mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/ap

/obj/item/ammo_magazine/a5_56mm/saw/hunter
	name = "magazine box (5.56mm hunting)"
	ammo_preload = /obj/item/ammo_casing/a5_56mm/hunter

/obj/item/ammo_magazine/a5_56mm/saw/empty
	icon_state = "a556-0"
	ammo_current = 0
