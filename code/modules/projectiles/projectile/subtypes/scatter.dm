
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

/obj/projectile/scatter/laser/weak
	damage_force = 15

	submunitions = list(
		/obj/projectile/beam/weaklaser = 3
		)

/obj/projectile/scatter/laser/pulse //Badmin only.
	damage_force = 100
	armor_penetration = 100
	submunitions = list(
		/obj/projectile/beam/pulse = 3
		)

/obj/projectile/scatter/gamma
	damage_force = 10
	submunition_spread_max = 60
	submunition_spread_min = 30
	submunitions = list(
		/obj/projectile/beam/gamma = 3
		)

/obj/projectile/scatter/laser/heavylaser
	damage_force = 60
	armor_penetration = 30
	submunitions = list(
		/obj/projectile/beam/heavylaser = 1 //nope
		)

/obj/projectile/scatter/laser/heavylaser/cannon
	damage_force = 80
	armor_penetration = 50
	submunitions = list(
		/obj/projectile/beam/heavylaser/cannon = 1 //haha no
		)

/obj/projectile/scatter/stun
	submunition_spread_max = 70
	submunition_spread_min = 30
	submunitions = list(
		/obj/projectile/beam/stun = 2
		)
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = 1
	agony = 40

/obj/projectile/scatter/stun/weak
	submunitions = list(
		/obj/projectile/beam/stun/weak = 2
		)
	agony = 20

/obj/projectile/scatter/stun/electrode
	submunitions = list(
		/obj/projectile/energy/electrode = 1
		)
	agony = 55

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

/obj/projectile/scatter/shock
	damage_force = 25
	submunition_spread_max = 80
	submunition_spread_min = 20
	submunitions = list(
		/obj/projectile/beam/shock = 6
		)

/obj/projectile/scatter/energy_net
	submunition_spread_max = 80
	submunition_spread_min = 30
	submunitions = list(
		/obj/projectile/beam/energy_net = 2
		)
	nodamage = 1
	agony = 5

/obj/projectile/scatter/phase
	damage_force = 5
	submunition_spread_max = 70
	submunition_spread_min = 30
	submunitions = list(
		/obj/projectile/energy/phase/heavy = 4
		)
