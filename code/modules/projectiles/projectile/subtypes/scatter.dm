
/*
 * Home of the purely submunition projectiles.
 */
/obj/projectile/scatter
	name = "scatter projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"

	submunitions_only = TRUE
	submunition_distribution = TRUE

/obj/projectile/scatter/flak_shotgun
	damage_force = 24
	damage_tier = 3
	submunitions = 3
	submunition_dispersion = 17.5
	submunition_type = /obj/projectile/bullet/pellet/shotgun/flak

/obj/projectile/scatter/heavy_shotgun
	damage_force = 60
	damage_tier = 3
	submunitions = 5
	submunition_dispersion = 30
	submunition_type = /obj/projectile/bullet/pellet/heavy_shotgun

/obj/projectile/scatter/heavy_shotgun/silver
	submunition_type = /obj/projectile/bullet/pellet/heavy_shotgun/silver

/obj/projectile/scatter/heavy_shotgun/grit
	submunition_type = /obj/projectile/bullet/pellet/heavy_shotgun/grit

/obj/projectile/scatter/laser
	damage_force = 75
	damage_tier = 3
	damage_flag = ARMOR_LASER
	submunitions = 6
	submunition_dispersion = 22.5
	submunition_type = /obj/projectile/beam/blaster/pellet

/obj/projectile/scatter/ion
	submunitions = 3
	submunition_dispersion = 30
	submunition_type = /obj/projectile/bullet/shotgun/ion

/obj/projectile/scatter/excavation
	damage_force = 10
	damage_tier = 4
	damage_flag = ARMOR_LASER
	submunition_dispersion = 30
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	submunitions = 3
	submunition_type = /obj/projectile/beam/excavation
