/datum/ammo_caliber/musket
	id = "musket"
	caliber = "musket"

/obj/item/ammo_casing/musket
	name = "musket ball"
	desc = "A solid ball made of lead."
	icon = 'icons/modules/projectiles/casings/musket.dmi'
	icon_state = "musketball"
	casing_caliber = /datum/ammo_caliber/musket
	projectile_type = /obj/projectile/bullet/musket
	materials_base = list("lead" = 100)
	casing_flags = CASING_DELETE

/obj/item/ammo_casing/musket/silver
	name = "silver musket ball"
	desc = "A solid ball made of a lead-silver alloy."
	icon_state = "silverball"
	projectile_type = /obj/projectile/bullet/musket/silver
	materials_base = list("lead" = 50, "silver" = 50)
