
/obj/projectile/beam/energy_net
	name = "energy net projection"
	icon_state = "xray"
	nodamage = 1
	agony = 5
	damage_type = HALLOSS
	light_color = "#00CC33"

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/xray
	hitscan_tracer_type = /obj/effect/projectile/tracer/xray
	hitscan_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/energy_net/on_hit(var/atom/netted)
	do_net(netted)
	..()

/obj/projectile/beam/energy_net/proc/do_net(var/mob/M)
	var/obj/item/energy_net/net = new (get_turf(M))
	net.throw_impact(M)

/obj/projectile/beam/medigun
	name = "healing beam"
	icon_state = "healbeam"
	damage = 0 //stops it damaging walls
	nodamage = TRUE
	no_attack_log = TRUE
	damage_type = BURN
	damage_flag = ARMOR_LASER
	light_color = "#80F5FF"

	combustion = FALSE

	hitscan_muzzle_type = /obj/effect/projectile/muzzle/medigun
	hitscan_tracer_type = /obj/effect/projectile/tracer/medigun
	hitscan_impact_type = /obj/effect/projectile/impact/medigun

/obj/projectile/beam/medigun/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(M.health < M.maxHealth)
			var/obj/effect/overlay/pulse = new /obj/effect/overlay(get_turf(M))
			pulse.icon = 'icons/effects/effects.dmi'
			pulse.icon_state = "heal"
			pulse.name = "heal"
			pulse.anchored = 1
			spawn(20)
				qdel(pulse)
			to_chat(target, "<span class='notice'>As the beam strikes you, your injuries close up!</span>")
			M.adjustBruteLoss(-15)
			M.adjustFireLoss(-15)
			M.adjustToxLoss(-5)
			M.adjustOxyLoss(-5)
	return 1
