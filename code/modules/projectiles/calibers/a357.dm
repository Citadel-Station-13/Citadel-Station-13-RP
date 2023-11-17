/datum/caliber/a357
	caliber = ".357"
	diameter = 9.1
	length = 40

//* Casings

/obj/item/ammo_casing/a357
	name = "bullet casing (.357)"
	desc = "A .357 bullet casing."
	icon = 'icons/modules/projectiles/casings/slim.dmi'
	icon_state = "small"
	base_icon_state = "small"
	projectile_type = /obj/projectile/bullet/pistol/strong
	materials_base = list(MAT_STEEL = 210)
	regex_this_caliber = /datum/caliber/a357

/obj/item/ammo_casing/a357/silver
	desc = "A .357 silver bullet casing. Bless and Sancitfied to banish otherworlds entities."
	icon_state = "small-silver"
	base_icon_state = "small-silver"
	materials_base = list(MAT_STEEL = 350, MAT_SILVER = 200)

//* Magazines - Speedloaders
