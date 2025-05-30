/datum/ammo_caliber/blunderbuss
	id = "blunderbuss"
	caliber = "blunderbuss"

/obj/item/ammo_casing/blunderbuss
	name = "shot"
	desc = "A bundle of lead balls and other assorted shrapnel."
	icon = 'icons/modules/projectiles/casings/blunderbuss.dmi'
	icon_state = "blunderbuss"
	casing_caliber = /datum/ammo_caliber/blunderbuss
	projectile_type = /obj/projectile/bullet/pellet/blunderbuss
	materials_base = list("lead" = 500)

/obj/item/ammo_casing/blunderbuss/silver
	name = "sliver shot"
	desc = "A bundle of silver-lead alloy balls and other assorted bits of silver."
	icon_state = "silverbuss"
	projectile_type = /obj/projectile/bullet/pellet/blunderbuss/silver
	materials_base = list("lead" = 250, "silver" = 250)
