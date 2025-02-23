
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
	submunition_dispersion = 17.5
	submunitions = list(
		/obj/projectile/bullet/pellet/shotgun/flak = 3,
	)

/obj/projectile/scatter/heavy_shotgun
	damage_force = 60
	damage_tier = BULLET_TIER_MEDIUM
	submunition_dispersion = 30
	submunitions = list(
		/obj/projectile/bullet/pellet/heavy_shotgun = 5,
	)

/obj/projectile/scatter/heavy_shotgun/silver
	submunitions = list(
		/obj/projectile/bullet/pellet/heavy_shotgun/silver = 5,
	)

/obj/projectile/scatter/heavy_shotgun/grit
	submunitions = list(
		/obj/projectile/bullet/pellet/heavy_shotgun/grit = 5,
	)

/obj/projectile/scatter/laser
	damage_force = 75
	damage_tier = BULLET_TIER_MEDIUM
	submunition_dispersion = 22.5
	submunitions = list(
		/obj/projectile/beam/blaster/pellet = 6,
	)

/obj/projectile/scatter/ion
	submunition_dispersion = 30
	submunitions = list(
		/obj/projectile/bullet/shotgun/ion = 3,
	)

/obj/projectile/scatter/excavation
	damage_force = 10
	damage_tier = LASER_TIER_HIGH
	submunition_dispersion = 30
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	submunitions = list(
		/obj/projectile/beam/excavation = 3,
	)
