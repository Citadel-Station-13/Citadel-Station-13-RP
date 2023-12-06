/datum/caliber/a10mm
	caliber = "10mm"

/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/projectile/bullet/pistol/medium
	materials_base = list(MAT_STEEL = 75)

/obj/item/ammo_casing/a10mm/emp
	name = "10mm haywire round"
	desc = "A 10mm bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/projectile/ion/small
	icon_state = "empcasing"
	materials_base = list(MAT_STEEL = 130, MAT_URANIUM = 100)

/obj/item/ammo_magazine/m10mm
	name = "magazine (10mm)"
	icon_state = "10mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	materials_base = list(MAT_STEEL = 1500)
	ammo_preload = /obj/item/ammo_casing/a10mm
	ammo_max = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/m10mm/empty
	ammo_current = 0

/obj/item/ammo_magazine/clip/c10mm
	name = "ammo clip (10mm)"
	icon_state = "clip_pistol"
	desc = "A stripper clip for reloading 5mm rounds into magazines."
	caliber = "10mm"
	ammo_preload = /obj/item/ammo_casing/a10mm
	materials_base = list(MAT_STEEL = 675) // metal costs are very roughly based around one 10mm casing = 75 metal
	ammo_max = 9
	multiple_sprites = 1

/obj/item/ammo_magazine/box/emp/b10
	name = "ammunition box (10mm haywire)"
	ammo_preload = /obj/item/ammo_casing/a10mm/emp
