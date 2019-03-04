/obj/item/projectile/beam/disable
    name = "disabler beam"
    icon_state = "omnilaser"
    nodamage = 1
    taser_effect = 1
    agony = 100 //One shot stuns for the time being until adjustments are fully made.
    damage_type = HALLOSS
    light_color = "#00CECE"

    muzzle_type = /obj/effect/temp_visual/projectile/muzzle/laser_omni
    tracer_type = /obj/effect/temp_visual/projectile/tracer/laser_omni
    impact_type = /obj/effect/temp_visual/projectile/impact/laser_omni

/obj/item/projectile/beam/stun
	agony = 35

/obj/item/projectile/beam/energy_net
	name = "energy net projection"
	icon_state = "xray"
	nodamage = 1
	agony = 5
	damage_type = HALLOSS
	light_color = "#00CC33"

	muzzle_type = /obj/effect/temp_visual/projectile/muzzle/xray
	tracer_type = /obj/effect/temp_visual/projectile/tracer/xray
	impact_type = /obj/effect/temp_visual/projectile/impact/xray

/obj/item/projectile/beam/energy_net/on_hit(atom/netted, blocked)
	. = ..()
	if(blocked < 100)
		do_net(netted)

/obj/item/projectile/beam/energy_net/proc/do_net(mob/M)
	var/obj/item/weapon/energy_net/net = new (get_turf(M))
	net.ensnare(M)

/obj/item/projectile/beam/stun/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"

	muzzle_type = /obj/effect/temp_visual/projectile/muzzle/laser_blue
	tracer_type = /obj/effect/temp_visual/projectile/tracer/laser_blue
	impact_type = /obj/effect/temp_visual/projectile/impact/laser_blue
