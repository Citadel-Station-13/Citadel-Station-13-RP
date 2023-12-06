/datum/caliber/a7_62mm
	caliber = "7.62mm"

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "7.62mm"
	icon_state = "rifle-casing"
	projectile_type = /obj/projectile/bullet/rifle/a762
	materials_base = list(MAT_STEEL = 200)

/obj/item/ammo_casing/a762/ap
	desc = "A 7.62mm armor-piercing bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a762/ap
	materials_base = list(MAT_STEEL = 300)

/obj/item/ammo_casing/a762/practice
	desc = "A 7.62mm practice bullet casing."
	icon_state = "rifle-casing" // Need to make an icon for these
	projectile_type = /obj/projectile/bullet/practice
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a762/blank
	desc = "A blank 7.62mm bullet casing."
	projectile_type = /obj/projectile/bullet/blank
	materials_base = list(MAT_STEEL = 90)

/obj/item/ammo_casing/a762/hp
	desc = "A 7.62mm hollow-point bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a762/hp

/obj/item/ammo_casing/a762/hunter
	desc = "A 7.62mm hunting bullet casing."
	projectile_type = /obj/projectile/bullet/rifle/a762/hunter

/obj/item/ammo_casing/a762/sniper
	desc = "A 7.62mm high velocity bullet casing optimised for a marksman rifle."
	projectile_type = /obj/projectile/bullet/rifle/a762/sniper

/obj/item/ammo_casing/a762/sniperhunter
	desc = "A 7.62mm high velocity hunter bullet casing optimised for a marksman rifle."
	projectile_type = /obj/projectile/bullet/rifle/a762/sniperhunter

/obj/item/ammo_casing/a762/silver
	desc = "A 7.62mm hunting bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "agrifle-casing"
	projectile_type = /obj/projectile/bullet/rifle/a762/silver
	materials_base = list(MAT_STEEL = 300, MAT_SILVER = 150)

/obj/item/ammo_magazine/m762
	name = "magazine (7.62mm)"
	icon_state = "m762-small"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 2000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762/empty
	ammo_current = 0

/obj/item/ammo_magazine/m762m // Intentionally not a subtype of m762 because it's supposed to be incompatible with the Z8 Bulldog rifle.
	name = "magazine (7.62mm)"
	icon_state = "m762"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 4000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m762m/ap
	name = "magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762m/empty
	ammo_current = 0

/obj/item/ammo_magazine/m762garand
	name = "garand clip (7.62mm)" // The clip goes into the magazine, hence the name. I'm very sure this is correct.
	icon_state = "gclip"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 1600)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 8
	multiple_sprites = 1

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
	ammo_current = 0

/obj/item/ammo_magazine/clip/c762
	name = "ammo clip (7.62mm)"
	icon_state = "clip_rifle"
	caliber = "7.62mm"
	ammo_preload = /obj/item/ammo_casing/a762
	materials_base = list(MAT_STEEL = 1000) // metal costs are very roughly based around one 7.62 casing = 200 metal
	ammo_max = 5
	multiple_sprites = 1

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
	icon_state = "agclip_rifle"
	ammo_preload = /obj/item/ammo_casing/a762/silver
	materials_base = list(MAT_STEEL = 1500, MAT_SILVER = 750)

/obj/item/ammo_magazine/m762svd
	name = "\improper SVD magazine (7.62mm)"
	icon_state = "SVD"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 2000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/m762svd/ap
	name = "\improper SVD magazine (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762svd/empty
	ammo_current = 0

/obj/item/ammo_magazine/m762_mg42
	name = "antique ammo drum (7.62mm)"
	icon_state = "mg42_drum"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 10000)
	ammo_preload = /obj/item/ammo_casing/a762
	w_class = ITEMSIZE_NORMAL
	ammo_max = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/m762_mg42/ap
	name = "antique ammo drum box (7.62mm armor-piercing)"
	ammo_preload = /obj/item/ammo_casing/a762/ap

/obj/item/ammo_magazine/m762_mg42/empty
	ammo_current = 0

/obj/item/ammo_magazine/m762_m60
	name = "M60 belt (7.62mm)"
	icon_state = "M60MAG"
	mag_type = MAGAZINE
	caliber = "7.62mm"
	materials_base = list(MAT_STEEL = 20000)
	ammo_preload = /obj/item/ammo_casing/a762
	ammo_max = 75
	multiple_sprites = 1

/obj/item/ammo_magazine/m762_m60/empty
	ammo_current = 0
