/datum/caliber/blunderbuss
	caliber = "blunderbuss"

/obj/item/ammo_casing/musket/blunderbuss
	name = "shot"
	desc = "A bundle of lead balls and other assorted shrapnel."
	icon_state = "blunderbuss"
	caliber = "blunderbuss"
	projectile_type = /obj/projectile/bullet/pellet/blunderbuss
	materials_base = list("lead" = 500)

/obj/item/ammo_casing/musket/blunderbuss/silver
	name = "sliver shot"
	desc = "A bundle of silver lead allow balls and other assorted bits of silver."
	icon_state = "silverbuss"
	projectile_type = /obj/projectile/bullet/pellet/blunderbuss/silver
	materials_base = list("lead" = 500, "silver" = 500)
