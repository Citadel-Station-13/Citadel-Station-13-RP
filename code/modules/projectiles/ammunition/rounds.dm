

/*
 * .75 (aka Gyrojet Rockets, aka admin abuse)
 */

/obj/item/ammo_casing/a75
	desc = "A .75 gyrojet rocket sheathe."
	caliber = ".75"
	projectile_type = /obj/projectile/bullet/gyro
	materials_base = list(MAT_STEEL = 4000)

/*
 * 12.7mm (anti-materiel rifle round)
 */

/obj/item/ammo_casing/a127
	desc = "A 12.7mm shell."
	icon_state = "lcasing"
	caliber = "12.7mm"
	projectile_type = /obj/projectile/bullet/rifle/a127
	materials_base = list(MAT_STEEL = 1250)

/*
 * Misc
 */

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell_alt"
	projectile_type = /obj/projectile/bullet/srmrocket
	caliber = "rocket"
	materials_base = list(MAT_STEEL = 10000)

/obj/item/ammo_casing/rocket/weak
	name = "low-yield rocket shell"
	projectile_type = /obj/projectile/bullet/srmrocket/weak
	materials_base = list(MAT_STEEL = 5000)


/obj/item/ammo_casing/organic
	name = "biomatter globule"
	desc = "Globular biomatter rendered and ready for compression."
	caliber = "organic"
	icon_state = "globule"
	color = "#FFE0E2"
	projectile_type = /obj/projectile/bullet/organic
	materials_base = list("flesh" = 100)

/obj/item/ammo_casing/organic/wax
	name = "wax globule"
	desc = "Tacky wax rendered semi-solid and ready for compression."
	caliber = "apidean"
	icon_state = "globule"
	color = "#E6E685"
	projectile_type = /obj/projectile/bullet/organic/wax
	materials_base = list("wax" = 100)
