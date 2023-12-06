/datum/caliber/a7_62mm
	caliber = "7.62mm"

#warn a7_62mm/
/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	regex_this_caliber = /datum/caliber/a7_62mm
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "large"
	projectile_type = /obj/projectile/bullet/rifle/a762
	materials_base = list(MAT_STEEL = 200)

/obj/item/ammo_casing/a762/ap
	desc = "A 7.62mm armor-piercing bullet casing."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/rifle/a762/ap
	materials_base = list(MAT_STEEL = 300)

/obj/item/ammo_casing/a762/practice
	desc = "A 7.62mm practice bullet casing."
	icon_state = "large-white"
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/projectile/bullet/practice
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a762/blank
	desc = "A blank 7.62mm bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/blank
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a762/hp
	desc = "A 7.62mm hollow-point bullet casing."
	icon_state = "large-red"
	projectile_type = /obj/projectile/bullet/rifle/a762/hp

/obj/item/ammo_casing/a762/hunter
	desc = "A 7.62mm hunting bullet casing."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/rifle/a762/hunter

/obj/item/ammo_casing/a762/sniper
	desc = "A 7.62mm high velocity bullet casing optimised for a marksman rifle."
	icon_state = "large-blue"
	projectile_type = /obj/projectile/bullet/rifle/a762/sniper

/obj/item/ammo_casing/a762/sniperhunter
	desc = "A 7.62mm high velocity hunter bullet casing optimised for a marksman rifle."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/rifle/a762/sniperhunter

/obj/item/ammo_casing/a762/silver
	desc = "A 7.62mm hunting bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "large-white"
	projectile_type = /obj/projectile/bullet/rifle/a762/silver
	materials_base = list(MAT_STEEL = 300, MAT_SILVER = 150)


#warn a7_62mm/
/obj/item/ammo_magazine/m762
	name = "magazine (7.62mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "m762-1"
	base_icon_state = "m762"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 10

/obj/item/ammo_magazine/m762/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762/empty
	icon_state = "m762-0"
	ammo_current = 0

#warn convert to above
/obj/item/ammo_magazine/m762m // Intentionally not a subtype of m762 because it's supposed to be incompatible with the Z8 Bulldog rifle.
/obj/item/ammo_magazine/m762m/ap
/obj/item/ammo_magazine/m762m/empty

#warn a7_62mm/
/obj/item/ammo_magazine/m762garand
	name = "garand clip (7.62mm)" // The clip goes into the magazine, hence the name. I'm very sure this is correct.
	icon = 'icons/modules/projectiles/magazines/old_magazine_clip.dmi'
	icon_state = "gerand-8"
	base_icon_state = "gerand"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 8

	materials_base = list(MAT_STEEL = 800)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 8

/obj/item/ammo_magazine/m762garand/ap
	name = "garand clip (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762garand/hunter
	name = "garand clip (7.62mm Hunting)"
	ammo_preload = /obj/item/ammo_casing/a762/hunter

/obj/item/ammo_magazine/m762garand/sniperhunter
	name = "garand clip (7.62mm HV Hunting)"
	ammo_preload = /obj/item/ammo_casing/a762/sniperhunter

/obj/item/ammo_magazine/m762/empty
	icon_state = "gerand-0"
	ammo_current = 0

#warn a7_62mm/
/obj/item/ammo_magazine/clip/c762
	name = "ammo clip (7.62mm)"
	ammo_preload = /obj/item/ammo_casing/a762
	materials_base = list(MAT_STEEL = 1000)
	ammo_max = 5
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "rifle-5"
	base_icon_state = "rifle"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5

/obj/item/ammo_magazine/clip/c762/ap
	name = "rifle clip (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/clip/c762/practice
	name = "rifle clip (7.62mm practice)"
	ammo_preload = /obj/item/ammo_casing/a762/practice

/obj/item/ammo_magazine/clip/c762/hunter
	name = "rifle clip (7.62mm hunting)"
	ammo_preload = /obj/item/ammo_casing/a762/hunter

/obj/item/ammo_magazine/clip/c762/sniper
	name = "rifle clip (7.62mm HV)"
	ammo_preload = /obj/item/ammo_casing/a762/sniper

/obj/item/ammo_magazine/clip/c762/sniperhunter
	name = "rifle clip (7.62mm HV hunting)"
	ammo_preload = /obj/item/ammo_casing/a762/sniperhunter

/obj/item/ammo_magazine/clip/c762/silver
	name = "rifle clip (7.62mm silver)"
	icon_state = "rifle-silver-5"
	base_icon_state = "rifle-silver"
	ammo_preload = /obj/item/ammo_casing/a762/silver

#warn a7_62mm/
/obj/item/ammo_magazine/m762svd
	name = "\improper SVD magazine (7.62mm)"
	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 10

	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "svd-1"
	base_icon_state = "svd"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/m762svd/ap
	name = "\improper SVD magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762svd/empty
	icon_state = "svd-0"
	ammo_current = 0

#warn a7_62mm/
/obj/item/ammo_magazine/m762_mg42
	name = "antique ammo drum (7.62mm)"
	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a762
	w_class = ITEMSIZE_NORMAL
	ammo_max = 50

	icon = 'icons/modules/projectiles/magazines/old_magazine_drum.dmi'
	icon_state = "mg42-1"
	base_icon_state = "mg42"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/m762_mg42/ap
	name = "antique ammo drum box (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762_mg42/empty
	icon_state = "mg42-0"
	ammo_current = 0

#warn a7_62mm/
/obj/item/ammo_magazine/m762_m60
	name = "M60 belt (7.62mm)"
	materials_base = list(MAT_STEEL = 1000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 75

	icon = 'icons/modules/projectiles/magazines/old_magazine_box.dmi'
	icon_state = "m60-1"
	base_icon_state = "m60"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1

/obj/item/ammo_magazine/m762_m60/empty
	icon_state = "m60-0"
	ammo_current = 0
