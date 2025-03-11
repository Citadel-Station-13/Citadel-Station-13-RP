/datum/ammo_caliber/rocket
	id = "rocket"
	caliber = "rocket"

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell_alt"
	projectile_type = /obj/projectile/bullet/srmrocket
	casing_caliber = /datum/ammo_caliber/rocket
	materials_base = list(MAT_STEEL = 10000)

/obj/item/ammo_casing/rocket/weak
	name = "low-yield rocket shell"
	projectile_type = /obj/projectile/bullet/srmrocket/weak
	materials_base = list(MAT_STEEL = 5000)
