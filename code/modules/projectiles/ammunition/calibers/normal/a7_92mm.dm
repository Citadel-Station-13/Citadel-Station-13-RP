/datum/ammo_caliber/a7_92mm
	id = "a7_92mm"
	caliber = "7.92x33mm"

/obj/item/ammo_magazine/a7_92mm
	name = "box mag (7.92x33mm Kurz)"

	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "stg"

	ammo_caliber = /datum/ammo_caliber/a7_92mm
	ammo_preload = /obj/item/ammo_casing/a792
	ammo_max = 30

/obj/item/ammo_magazine/a7_92mm/empty
	ammo_current = 0

/obj/item/ammo_casing/a792
	desc = "A 7.92x33mm Kurz casing."
	icon_state = "rifle-casing"
	casing_caliber = /datum/ammo_caliber/a7_92mm
	projectile_type = /obj/projectile/bullet/rifle/a762
