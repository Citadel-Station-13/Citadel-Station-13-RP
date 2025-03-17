/datum/ammo_caliber/a9_5mm
	id = "a9_5mm"
	caliber = "9.5x40mm"
	diameter = 9.5
	length = 40

//* Casings *//

/obj/item/ammo_casing/a95
	desc = "A 9.5x40mm bullet casing."
	icon_state = "rifle-casing"
	casing_caliber = /datum/ammo_caliber/a9_5mm
	projectile_type = /obj/projectile/bullet/rifle/a95

//* Magazines *//

/obj/item/ammo_magazine/m95
	name = "box mag (9.5x40mm)"
	icon = 'icons/modules/projectiles/magazines/old_magazine_stick.dmi'
	icon_state = "battlerifle-20"
	base_icon_state = "battlerifle"
	ammo_caliber = /datum/ammo_caliber/a9_5mm
	ammo_preload = /obj/item/ammo_casing/a95
	ammo_max = 36
	rendering_count = 1
	rendering_system = GUN_RENDERING_STATES

/obj/item/ammo_magazine/m95/empty
	ammo_current = 0

//* Projectiles *//

/obj/projectile/bullet/rifle/a95
	damage_force = 40
