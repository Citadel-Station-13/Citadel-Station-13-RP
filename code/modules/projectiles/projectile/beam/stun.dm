/obj/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = 1
	taser_effect = 1
	agony = 35
	damage_type = HALLOSS
	light_color = "#FFFFFF"
	impact_sounds = null

	combustion = FALSE

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/stun
	hitscan_tracer_type = /obj/effect/projectile/tracer/stun
	hitscan_impact_type = /obj/effect/projectile/impact/stun

/obj/projectile/beam/stun/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_blue
	hitscan_impact_type = /obj/effect/projectile/impact/laser_blue

/obj/projectile/beam/stun/weak
	name = "weak stun beam"
	icon_state = "stun"
	agony = 25

/obj/projectile/beam/stun/med
	name = "stun beam"
	icon_state = "stun"
	agony = 30

/obj/projectile/beam/stun/disabler
	name = "disabler beam"
	icon_state = "stun"
	taser_effect = 0
	agony = 20

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
	hitscan_tracer_type = /obj/effect/projectile/tracer/laser_omni
	hitscan_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/stun/disabler/on_hit(atom/target, blocked = 0, def_zone)
	. = ..(target, blocked, def_zone)

	if(. && istype(target, /mob/living/silicon/robot) && prob(agony))
		var/mob/living/silicon/robot/R = target
		var/drainamt = agony * (rand(5, 15) / 10)
		// 100 to 300 drain
		R.drain_energy(DYNAMIC_CELL_UNITS_TO_KJ(drainamt * 10))
		if(istype(firer, /mob/living/silicon/robot)) // Mischevious sappers, the swarm drones are.
			var/mob/living/silicon/robot/A = firer
			if(A.cell)
				A.cell.give(drainamt * 2)

/obj/projectile/beam/disabler
	name = "disabler beam"
	icon_state = "lightning"
	fire_sound = 'sound/weapons/Taser.ogg'
	nodamage = 1
	taser_effect = 1
	agony = 30
	damage_type = HALLOSS
	light_color = "#FFFFFF"

	combustion = FALSE

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/lightning
	hitscan_tracer_type = /obj/effect/projectile/tracer/lightning
	hitscan_impact_type = /obj/effect/projectile/impact/lightning
	impact_sounds = null

/obj/projectile/beam/disabler/weak
	name = "weak disabler beam"
	icon_state = "lightning"
	agony = 25

/obj/projectile/beam/disabler/strong
	name = "strong disabler beam"
	icon_state = "lightning"
	agony = 40
