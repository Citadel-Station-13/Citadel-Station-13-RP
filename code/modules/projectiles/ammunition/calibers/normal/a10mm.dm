/datum/ammo_caliber/a10mm
	id = "a10mm"
	caliber = "10mm"

/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	casing_caliber = /datum/ammo_caliber/a10mm
	projectile_type = /obj/projectile/bullet/pistol/medium
	materials_base = list(MAT_STEEL = 75)

/obj/item/ammo_casing/a10mm/emp
	name = "10mm haywire round"
	desc = "A 10mm bullet casing fitted with a single-use ion pulse generator."
	icon_state = "small-tech"
	projectile_type = /obj/projectile/ion/small
	materials_base = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_magazine/a10mm
	ammo_caliber = /datum/ammo_caliber/a10mm

/obj/item/ammo_magazine/a10mm
	name = "magazine (10mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "10mm-5"
	base_icon_state = "10mm"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 5
	materials_base = list(MAT_STEEL = 500)
	ammo_preload = /obj/item/ammo_casing/a10mm
	ammo_max = 20

/obj/item/ammo_magazine/a10mm/empty
	icon_state = "10mm-0"
	ammo_current = 0

/obj/item/ammo_magazine/a10mm/clip
	name = "ammo clip (10mm)"
	desc = "A stripper clip for reloading 5mm rounds into magazines."
	icon = 'icons/modules/projectiles/magazines/old_stripper.dmi'
	icon_state = "pistol-10"
	base_icon_state = "pistol"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 9
	magazine_type = MAGAZINE_TYPE_CLIP
	ammo_preload = /obj/item/ammo_casing/a10mm
	materials_base = list(MAT_STEEL = 250)
	ammo_max = 9
