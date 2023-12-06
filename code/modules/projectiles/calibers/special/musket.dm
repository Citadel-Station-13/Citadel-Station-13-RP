/datum/caliber/musket
	caliber = "musket"

/obj/item/ammo_casing/musket
	name = "musket ball"
	desc = "A solid ball made of lead."
	icon_state = "musketball"
	caliber = "musket"
	projectile_type = /obj/projectile/bullet/musket
	materials_base = list("lead" = 100)
	casing_flags = CASING_DELETE

/obj/item/ammo_casing/musket/silver
	name = "silver musket ball"
	desc = "A solid ball made of a lead-silver alloy."
	icon_state = "silverball"
	projectile_type = /obj/projectile/bullet/musket/silver
	materials_base = list("lead" = 100, "silver" = 100)
