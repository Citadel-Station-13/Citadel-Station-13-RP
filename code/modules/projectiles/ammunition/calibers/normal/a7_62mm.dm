/datum/ammo_caliber/a7_62mm
	id = "a7_62mm"
	caliber = "7.62mm"

//* Casings *//

/obj/item/ammo_casing/a7_62mm
	desc = "A 7.62mm bullet casing."
	casing_caliber = /datum/ammo_caliber/a7_62mm
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "large"
	projectile_type = /obj/projectile/bullet/rifle/a762
	materials_base = list(MAT_STEEL = 200)
	worth_intrinsic = 5

/obj/item/ammo_casing/a7_62mm/ap
	desc = "A 7.62mm armor-piercing bullet casing."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/rifle/a762/ap
	materials_base = list(MAT_STEEL = 300)
	worth_intrinsic = 7.5

/obj/item/ammo_casing/a7_62mm/practice
	desc = "A 7.62mm practice bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/practice
	materials_base = list(MAT_STEEL = 90)
	worth_intrinsic = 1.5

/obj/item/ammo_casing/a7_62mm/blank
	desc = "A blank 7.62mm bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/blank
	materials_base = list(MAT_STEEL = 90)
	worth_intrinsic = 1.5

/obj/item/ammo_casing/a7_62mm/hp
	desc = "A 7.62mm hollow-point bullet casing."
	icon_state = "large-red"
	projectile_type = /obj/projectile/bullet/rifle/a762/hp

/obj/item/ammo_casing/a7_62mm/hunter
	desc = "A 7.62mm hunting bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/rifle/a762/hunter

/obj/item/ammo_casing/a7_62mm/sniper
	desc = "A 7.62mm high velocity bullet casing optimised for a marksman rifle."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/rifle/a762/sniper

/obj/item/ammo_casing/a7_62mm/sniperhunter
	desc = "A 7.62mm high velocity hunter bullet casing optimised for a marksman rifle."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/rifle/a762/sniperhunter

/obj/item/ammo_casing/a7_62mm/silver
	desc = "A 7.62mm silver bullet casing."
	icon_state = "large-silver"
	projectile_type = /obj/projectile/bullet/rifle/a762/silver
	materials_base = list(MAT_STEEL = 150, MAT_SILVER = 100)

//* Magazines *//

/obj/item/ammo_magazine/a7_62mm
	name = "magazine (7.62mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "m762-1"
	base_icon_state = "m762"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a7_62mm
	ammo_caliber = /datum/ammo_caliber/a7_62mm
	ammo_max = 10

/obj/item/ammo_magazine/a7_62mm/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/ap

/obj/item/ammo_magazine/a7_62mm/silver
	name = "magazine (7.62mm silver)"
	icon_state = "m762ag-1"
	base_icon_state = "m762ag"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/silver

/obj/item/ammo_magazine/a7_62mm/empty
	icon_state = "m762-0"
	ammo_current = 0

/obj/item/ammo_magazine/a7_62mm/garand
	name = "garand magazine (7.62mm)" // The clip goes into the magazine, hence the name. I'm very sure this is correct.
	icon = 'icons/modules/projectiles/magazines/old_magazine_clip.dmi'
	icon_state = "garand-8"
	base_icon_state = "garand"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 8

	materials_base = list(MAT_STEEL = 800)
	ammo_preload = /obj/item/ammo_casing/a7_62mm
	ammo_max = 8

/obj/item/ammo_magazine/a7_62mm/garand/ap
	name = "garand clip (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/ap

/obj/item/ammo_magazine/a7_62mm/garand/hunter
	name = "garand clip (7.62mm Hunting)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/hunter

/obj/item/ammo_magazine/a7_62mm/garand/sniperhunter
	name = "garand clip (7.62mm HV Hunting)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/sniperhunter

/obj/item/ammo_magazine/a7_62mm/empty
	icon_state = "gerand-0"
	ammo_current = 0

/obj/item/ammo_magazine/a7_62mm/clip
	name = "rifle clip (7.62mm)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm
	materials_base = list(MAT_STEEL = 1000)
	ammo_max = 5
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "rifle-5"
	base_icon_state = "rifle"
	magazine_type = MAGAZINE_TYPE_CLIP
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5

/obj/item/ammo_magazine/a7_62mm/clip/ap
	name = "rifle clip (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/ap

/obj/item/ammo_magazine/a7_62mm/clip/practice
	name = "rifle clip (7.62mm practice)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/practice

/obj/item/ammo_magazine/a7_62mm/clip/hunter
	name = "rifle clip (7.62mm hunting)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/hunter

/obj/item/ammo_magazine/a7_62mm/clip/sniper
	name = "rifle clip (7.62mm HV)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/sniper

/obj/item/ammo_magazine/a7_62mm/clip/sniperhunter
	name = "rifle clip (7.62mm HV hunting)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/sniperhunter

/obj/item/ammo_magazine/a7_62mm/clip/silver
	name = "rifle clip (7.62mm silver)"
	icon_state = "rifle-silver-5"
	base_icon_state = "rifle-silver"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/silver

/obj/item/ammo_magazine/a7_62mm/svd
	name = "\improper SVD magazine (7.62mm)"
	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a7_62mm
	ammo_max = 10

	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "svd-1"
	base_icon_state = "svd"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/a7_62mm/svd/ap
	name = "\improper SVD magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/ap

/obj/item/ammo_magazine/a7_62mm/svd/empty
	icon_state = "svd-0"
	ammo_current = 0

/obj/item/ammo_magazine/a7_62mm/mg42
	name = "antique ammo drum (7.62mm)"
	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a7_62mm
	w_class = WEIGHT_CLASS_NORMAL
	ammo_max = 50

	icon = 'icons/modules/projectiles/magazines/old_magazine_drum.dmi'
	icon_state = "mg42-1"
	base_icon_state = "mg42"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/a7_62mm/mg42/ap
	name = "antique ammo drum box (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/ap

/obj/item/ammo_magazine/a7_62mm/mg42/empty
	icon_state = "mg42-0"
	ammo_current = 0

/obj/item/ammo_magazine/a7_62mm/m60
	name = "M60 belt (7.62mm)"
	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a7_62mm
	ammo_max = 75

	icon = 'icons/modules/projectiles/magazines/old_magazine_box.dmi'
	icon_state = "m60-1"
	base_icon_state = "m60"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/a7_62mm/m60/empty
	icon_state = "m60-0"
	ammo_current = 0

/obj/item/ammo_magazine/a7_62mm/extended
	name = "extended magazine (7.62mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "m762-ext-1"
	base_icon_state = "m762-ext"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	materials_base = list(MAT_STEEL = 1200)
	ammo_preload = /obj/item/ammo_casing/a7_62mm
	ammo_caliber = /datum/ammo_caliber/a7_62mm
	ammo_max = 20

/obj/item/ammo_magazine/a7_62mm/extended/silver
	name = "extended magazine (7.62mm silver)"
	icon_state = "m762ag-ext-1"
	base_icon_state = "m762ag-ext"
	ammo_preload = /obj/item/ammo_casing/a7_62mm/silver
