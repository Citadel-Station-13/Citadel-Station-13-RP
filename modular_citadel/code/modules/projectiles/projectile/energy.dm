/*
	egun projectiles go here
*/

/obj/item/projectile/beam/stun/disabler	//pseudo disabler
	name = "disabler beam"
	icon_state = "stun"
	taser_effect = 0
	agony = 20

	muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	tracer_type = /obj/effect/projectile/tracer/laser_omni
	impact_type = /obj/effect/projectile/impact/laser_omni

/obj/item/projectile/energy/electrode/goldenbolt	//MIGHTY GOLDEN BOLT
	name = "taser bolt"
	agony = 80