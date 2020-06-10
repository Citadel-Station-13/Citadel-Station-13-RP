
/*
 * Home of the purely submunition projectiles.
 */

/obj/item/projectile/scatter
	name = "scatter projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = FALSE
	anchored = TRUE
	unacidable = TRUE
	pass_flags = PASSTABLE
	mouse_opacity = 0

	use_submunitions = TRUE

	damage = 8
	spread_submunition_damage = TRUE
	only_submunitions = TRUE
	range = 0	// Immediately deletes itself after firing, as its only job is to fire other projectiles.

	submunition_spread_max = 30
	submunition_spread_min = 2

	submunitions = list(
		/obj/item/projectile/bullet/pellet/shotgun/flak = 3
		)

/obj/item/projectile/scatter/laser
	damage = 40

	submunition_spread_max = 40
	submunition_spread_min = 10

	submunitions = list(
		/obj/item/projectile/beam = 4
		)

/obj/item/projectile/scatter/laser/weak
	damage = 15

	submunitions = list(
		/obj/item/projectile/beam/weaklaser = 3
		)

/obj/item/projectile/scatter/laser/pulse //Badmin only.
	damage = 100
	armor_penetration = 100
	submunitions = list(
		/obj/item/projectile/beam/pulse = 3
		)

/obj/item/projectile/scatter/gamma
	damage = 10
	submunition_spread_max = 40
	submunition_spread_min = 10
	submunitions = list(
		/obj/item/projectile/beam/gamma = 3
		)

/obj/item/projectile/scatter/laser/heavylaser
	damage = 60
	armor_penetration = 30
	submunitions = list(
		/obj/item/projectile/beam/heavylaser = 3
		)


/obj/item/projectile/scatter/laser/heavylaser/cannon
	damage = 80
	armor_penetration = 50
	submunitions = list(
		/obj/item/projectile/beam/heavylaser/cannon = 2
		)


/obj/item/projectile/scatter/stun
	submunition_spread_max = 40
	submunition_spread_min = 10
	submunitions = list(
		/obj/item/projectile/beam/stun = 4
		)
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = 1
	agony = 40

/obj/item/projectile/scatter/stun/weak
	submunitions = list(
		/obj/item/projectile/beam/stun/weak = 4
		)
	agony = 20

/obj/item/projectile/scatter/stun/electrode
	submunitions = list(
		/obj/item/projectile/energy/electrode = 3
		)
	agony = 55

/obj/item/projectile/scatter/ion
	damage = 20

	submunition_spread_max = 40
	submunition_spread_min = 10

	submunitions = list(
		/obj/item/projectile/bullet/shotgun/ion = 3
		)

/obj/item/projectile/scatter/excavation
	damage = 10
	submunition_spread_max = 50
	submunition_spread_min = 20
	submunitions = list(
		/obj/item/projectile/beam/excavation = 2
		)

/obj/item/projectile/scatter/shock
	damage = 25
	submunition_spread_max = 80
	submunition_spread_min = 20
	submunitions = list(
		/obj/item/projectile/beam/shock = 6
		)

/obj/item/projectile/scatter/energy_net
	submunition_spread_max = 40
	submunition_spread_min = 10
	submunitions = list(
		/obj/item/projectile/beam/energy_net = 2
		)
	nodamage = 1
	agony = 5

/obj/item/projectile/scatter/phase
	damage = 5
	submunition_spread_max = 50
	submunition_spread_min = 20
	submunitions = list(
		/obj/item/projectile/energy/phase/heavy = 4
		)
