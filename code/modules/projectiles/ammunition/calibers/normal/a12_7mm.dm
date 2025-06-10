/datum/ammo_caliber/a12_7mm
	id = "a12_7mm"
	caliber = "12.7mm"

/obj/item/ammo_casing/a12_7mm
	desc = "A 12.7mm shell."
	icon = 'icons/modules/projectiles/casings/a12_7mm.dmi'
	icon_state = "casing"
	icon_spent = TRUE
	casing_caliber = /datum/ammo_caliber/a12_7mm
	projectile_type = /obj/projectile/bullet/rifle/a12_7mm
	materials_base = list(MAT_STEEL = 1250)

/obj/item/ammo_casing/a12_7mm/phoron
	name = "caseless phoron round"
	desc = "A 12.7mm caseless round."
	casing_caliber = /datum/ammo_caliber/a12_7mm
	projectile_type = /obj/projectile/bullet/incendiary/caseless
	casing_flags = CASING_DELETE
