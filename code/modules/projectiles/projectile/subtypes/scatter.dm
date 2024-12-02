
/*
 * Home of the purely submunition projectiles.
 */
/obj/projectile/scatter
	name = "scatter projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"

	use_submunitions = TRUE

	damage_force = 8
	spread_submunition_damage = TRUE
	only_submunitions = TRUE
	range = WORLD_ICON_SIZE * 0	// Immediately deletes itself after firing, as its only job is to fire other projectiles.

	submunition_spread_max = 30
	submunition_spread_min = 2

	submunitions = list(
		/obj/projectile/bullet/pellet/shotgun/flak = 3
		)

//Spread Shot
/obj/projectile/scatter/heavy_shotgun
	damage_force = 15

	submunition_spread_max = 100
	submunition_spread_min = 30

	submunitions = list(
		/obj/projectile/bullet/pellet/heavy_shotgun = 5
		)

/obj/projectile/scatter/heavy_shotgun/accurized
	damage_force = 15

	submunition_spread_max = 30
	submunition_spread_min = 10

	submunitions = list(
		/obj/projectile/bullet/pellet/heavy_shotgun = 5
		)

/obj/projectile/scatter/heavy_shotgun/silver
	damage_force = 15

	submunition_spread_max = 30
	submunition_spread_min = 10

	submunitions = list(
		/obj/projectile/bullet/pellet/heavy_shotgun/silver = 5
		)

//Custom knockback buckshot variant for Grit.
/obj/projectile/scatter/heavy_shotgun/grit

	submunitions = list(
		/obj/projectile/bullet/pellet/heavy_shotgun/grit = 5
		)

//Energy Scatter
/obj/projectile/scatter/laser
	submunition_spread_max = 30
	spread_submunition_damage = FALSE
	submunition_constant_spread = TRUE

	submunitions = list(
		/obj/projectile/beam/blaster/pellet = 6
		)

/obj/projectile/scatter/ion
	damage_force = 0

	submunition_spread_max = 60
	submunition_constant_spread = TRUE

	submunitions = list(
		/obj/projectile/bullet/shotgun/ion = 3
		)

/obj/projectile/scatter/excavation
	damage_force = 2 //mining tool
	submunition_spread_max = 80
	submunition_spread_min = 40
	fire_sound = 'sound/weapons/weaponsounds_laserweak.ogg'
	submunitions = list(
		/obj/projectile/beam/excavation = 2
		)
