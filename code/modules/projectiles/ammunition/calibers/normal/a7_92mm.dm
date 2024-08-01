/datum/caliber/a7_92mm
	caliber = "7.92x33mm"

/obj/item/ammo_magazine/a7_92mm
	name = "box mag (7.92x33mm Kurz)"
	icon = 'icons/obj/ammo_vr.dmi'
	icon_state = "stg_30rnd"
	caliber = "7.92x33mm"
	ammo_type = /obj/item/ammo_casing/a792
	max_ammo = 30
	mag_type = MAGAZINE

/obj/item/ammo_magazine/a7_92mm/empty
	initial_ammo = 0

/obj/item/ammo_casing/a792
	desc = "A 7.92x33mm Kurz casing."
	icon_state = "rifle-casing"
	caliber = "7.92x33mm"
	projectile_type = /obj/projectile/bullet/rifle/a762
