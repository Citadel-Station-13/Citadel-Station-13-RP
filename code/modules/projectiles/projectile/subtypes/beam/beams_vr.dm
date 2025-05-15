/obj/projectile/beam/disable
    name = "disabler beam"
    icon_state = "omnilaser"
    nodamage = 1
    damage_inflict_agony = 40
    damage_type = DAMAGE_TYPE_HALLOSS
    light_color = "#00CECE"

    legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_omni
    legacy_tracer_type = /obj/effect/projectile/tracer/laser_omni
    legacy_impact_type = /obj/effect/projectile/impact/laser_omni

/obj/projectile/beam/stun
	damage_inflict_agony = 35

/obj/projectile/beam/energy_net
	name = "energy net projection"
	icon_state = "xray"
	nodamage = 1
	damage_inflict_agony = 5
	damage_type = DAMAGE_TYPE_HALLOSS
	light_color = "#00CC33"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/xray
	legacy_tracer_type = /obj/effect/projectile/tracer/xray
	legacy_impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/energy_net/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(!ismob(target))
		return
	do_net(target)

/obj/projectile/beam/energy_net/proc/do_net(var/mob/M)
	var/obj/item/energy_net/net = new (get_turf(M))
	net.throw_impact(M)

/obj/projectile/beam/stun/blue
	icon_state = "bluelaser"
	light_color = "#0066FF"

	legacy_muzzle_type = /obj/effect/projectile/muzzle/laser_blue
	legacy_tracer_type = /obj/effect/projectile/tracer/laser_blue
	legacy_impact_type = /obj/effect/projectile/impact/laser_blue

/obj/projectile/beam/medigun
	name = "healing beam"
	icon_state = "healbeam"
	damage_force = 0 //stops it damaging walls
	nodamage = TRUE
	damage_type = DAMAGE_TYPE_BURN
	damage_flag = ARMOR_LASER
	light_color = "#80F5FF"

	combustion = FALSE

	legacy_muzzle_type = /obj/effect/projectile/muzzle/medigun
	legacy_tracer_type = /obj/effect/projectile/tracer/medigun
	legacy_impact_type = /obj/effect/projectile/impact/medigun

/obj/projectile/beam/medigun/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return

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
