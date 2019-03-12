/obj/item/projectile/beam/energy_net
	name = "energy net projection"
	icon_state = "xray"
	nodamage = 1
	agony = 5
	damage_type = HALLOSS
	light_color = "#00CC33"

	muzzle_type = /obj/effect/projectile/muzzle/xray
	tracer_type = /obj/effect/projectile/tracer/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/item/projectile/beam/energy_net/on_hit(atom/netted, blocked)
	. = ..()
	if(blocked < 100)
		do_net(netted)

/obj/item/projectile/beam/energy_net/proc/do_net(mob/M)
	var/obj/item/weapon/energy_net/net = new (get_turf(M))
	net.ensnare(M)
