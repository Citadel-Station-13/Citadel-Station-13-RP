/datum/ammo_caliber/a10g
	id = "a10g"
	caliber = "10g"

/obj/item/ammo_casing/a10g
	name = "heavy shotgun slug"
	desc = "A brass jacketed 10 gauge slug shell."
	icon = 'icons/modules/projectiles/casings/a10g.dmi'
	icon_state = "10ga_slug"
	icon_spent = FALSE
	casing_caliber = /datum/ammo_caliber/a10g
	projectile_type = /obj/projectile/bullet/heavy_shotgun
	materials_base = list(MAT_STEEL = 300, "brass" = 200)
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')

/obj/item/ammo_casing/a10g/pellet //Spread variant.
	name = "heavy shotgun shell"
	desc = "A brass jacketed 10 gauge shot shell."
	projectile_type = /obj/projectile/scatter/heavy_shotgun

/obj/item/ammo_casing/a10g/silver
	name = "heavy silver shotgun shell"
	desc = "A brass jacketed 10 gauge filled with silver shot."
	projectile_type = /obj/projectile/scatter/heavy_shotgun/silver

/obj/item/ammo_casing/a10g/grit
	name = "tooled heavy shotgun slug"
	desc = "A custom brass jacketed 10 gauge slug shell."
	projectile_type = /obj/projectile/bullet/heavy_shotgun/grit

/obj/item/ammo_casing/a10g/pellet/grit
	name = "tooled heavy shotgun shell"
	desc = "A custom brass jacketed 10 gauge shot shell."
	projectile_type = /obj/projectile/scatter/heavy_shotgun/grit
