
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
	damage_tier = BULLET_TIER_MEDIUM
	submunitions = 3
	submunition_dispersion = 17.5
	submunition_type = /obj/projectile/bullet/pellet/shotgun/flak

/obj/projectile/scatter/heavy_shotgun
	damage_force = 60
	damage_tier = BULLET_TIER_MEDIUM
	submunitions = 5
	submunition_dispersion = 30
	submunition_type = /obj/projectile/bullet/pellet/heavy_shotgun

/obj/projectile/scatter/heavy_shotgun/silver
	submunition_type = /obj/projectile/bullet/pellet/heavy_shotgun/silver

/obj/projectile/scatter/heavy_shotgun/grit
	submunition_type = /obj/projectile/bullet/pellet/heavy_shotgun/grit

/obj/projectile/scatter/laser
	damage_force = 75
	damage_tier = BULLET_TIER_MEDIUM
	submunitions = 6
	submunition_dispersion = 22.5
	submunition_type = /obj/projectile/beam/blaster/pellet

/obj/projectile/scatter/ion
	submunitions = 3
	submunition_dispersion = 30
	submunition_type = /obj/projectile/bullet/shotgun/ion

/obj/projectile/scatter/excavation
	damage_force = 10
	damage_tier = LASER_TIER_HIGH
	submunition_dispersion = 30
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	submunitions = 3
	submunition_type = /obj/projectile/beam/excavation
