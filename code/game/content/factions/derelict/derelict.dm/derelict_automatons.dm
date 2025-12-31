/mob/living/simple_mob/mechanical/sentinel
	name = "Sentinel"
	desc = "A large, bulky machine that has some type of grey energy shield hovering around it. Thrusters flank its side, constantly emitting powerful bursts of energy that keep the automaton upwards and mobile."

	icon = 'code/game/content/factions/derelict/derelict.dmi/automatons/48x48.dmi'
	icon_state = "sentinel"
	icon_living = "sentinel"
	icon_dead = "sentinel_dead"
	color = "#808080"
	base_pixel_x = -8

	iff_factions = MOB_IFF_FACTION_DERELICT_AUTOMATONS
	health = 250
	maxHealth = 250
	movement_base_speed = 10 / 4
	hovering = TRUE

	base_attack_cooldown = 20

	response_help = "shoves aside"
	response_disarm = "forces aside"
	response_harm = "smashes into"

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/intentional/adv_dark_gygax
	special_attack_min_range = 1
	special_attack_max_range = 7
	special_attack_cooldown = 1 SECONDS


	var/obj/item/shield_projector/shields = null

/mob/living/simple_mob/mechanical/sentinel/Initialize(mapload)
	shields = new /obj/item/shield_projector/rectangle/automatic/advanced(src)
	return ..()

/mob/living/simple_mob/mechanical/sentinel/Destroy()
	QDEL_NULL(shields)
	return ..()

/mob/living/simple_mob/mechanical/sentinel/death()
	..(null,"suddenly crashes to the ground, translucent blue blood leaking from a broken thruster.")


/mob/living/simple_mob/mechanical/combat_drone/Process_Spacemove(var/check_drift = 0)
	return TRUE

/obj/item/shield_projector/rectangle/automatic/advanced
	shield_health = 250
	max_shield_health = 250
	shield_regen_delay = 7 SECONDS
	shield_regen_amount = 30
	size_x = 1
	size_y = 1
	color = "#808080"
	high_color = "#808080"
	low_color = "#808080"
	light_color = "#2e0808"


/mob/living/simple_mob/mechanical/sentinel/do_special_attack(atom/A)
	. = TRUE // So we don't fire a bolt as well.
	switch(a_intent)
		if(INTENT_HELP) // Primary Laser
			primary(A)
		if(INTENT_DISARM) // Ion Cannon
			ion(A)
		if(INTENT_GRAB) // Net Gun
			net(A)
		if(INTENT_HARM) // Flame Thrower
			flame(A)


/mob/living/simple_mob/mechanical/sentinel/proc/primary(atom/target)
	projectiletype = /obj/projectile/beam/darkmatter/sentinel

/mob/living/simple_mob/mechanical/sentinel/proc/ion(atom/target)
	projectiletype = /obj/projectile/ion

/mob/living/simple_mob/mechanical/sentinel/proc/net(atom/target)
	projectiletype = /obj/projectile/beam/gravity_sphere/sentinel

/mob/living/simple_mob/mechanical/sentinel/proc/flame(atom/target)
	projectiletype = /obj/projectile/potent_fire/sentinel/scatter


/obj/item/gravity_sphere/sentinel
	name = "gravity sphere"
	desc = "A sphere made out of some sort of pulsing blue energy. It's keeping the person it's surrounding in place."
	icon = 'icons/effects/effects.dmi'
	icon_state = "gravisphere"
	throw_force = 0
	damage_force = 0
	var/net_type = /obj/effect/gravity_sphere/sentinel

/obj/item/gravity_sphere/sentinel/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	QDEL_IN(src, 10)

/obj/item/gravity_sphere/sentinel/throw_impact(atom/hit_atom)
	..()

	var/mob/living/M = hit_atom

	if(!istype(M) || locate(/obj/effect/gravity_sphere/sentinel) in M.loc)
		qdel(src)
		return 0

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/gravity_sphere/sentinel/net = new net_type(T)
		if(net.buckle_mob(M))
			T.visible_message("[M] was caught in a gravity sphere!")
		qdel(src)

	// If we miss or hit an obstacle, we still want to delete the net.
	spawn(10)
		if(src) qdel(src)

/obj/effect/gravity_sphere/sentinel
	name = "gravity sphere"
	desc = "A sphere made out of some sort of pulsing blue energy. It's keeping the person it's surrounding in place."
	icon = 'icons/effects/effects.dmi'
	icon_state = "gravisphere"

	var/escape_time = 8 SECONDS

	density = FALSE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_ICON
	anchored = FALSE

	buckle_allowed = TRUE
	buckle_flags = BUCKLING_NO_DEFAULT_BUCKLE
	buckle_restrained_resist_time = 0

/obj/effect/gravity_sphere/sentinel/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/gravity_sphere/sentinel/Destroy()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			to_chat(A,"<span class='notice'>You are free of the gravity sphere!</span>")
			unbuckle_mob(A)

	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/gravity_sphere/sentinel/process(delta_time)
	if(!has_buckled_mobs())
		qdel(src)

/obj/effect/gravity_sphere/sentinel/Move()
	..()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/occupant = A
			occupant.buckled = null
			occupant.forceMove(src.loc)
			occupant.buckled = src
			if (occupant && (src.loc != occupant.loc))
				unbuckle_mob(occupant)
				qdel(src)

/obj/effect/gravity_sphere/sentinel/mob_resist_buckle(mob/M, semantic)
	. = ..()
	if(!.)
		return
	M.setClickCooldownLegacy(M.get_attack_speed_legacy())
	visible_message("<span class='danger'>[M] begins to struggle in \the [src]!</span>")
	if(!do_after(M, escape_time, src, mobility_flags = MOBILITY_CAN_RESIST))
		return FALSE
	visible_message("<span class='danger'>[M] manages to struggle out of \the [src]</span>")
	qdel(src)
	return FALSE

/obj/effect/gravity_sphere/sentinel/mob_buckled(mob/M, flags, mob/user, semantic)
	. = ..()
	plane = M.plane + 10

/obj/projectile/potent_fire/sentinel
	name = "ember"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	modifier_type_to_apply = /datum/modifier/fire
	modifier_duration = 8 SECONDS
	damage_force = 0
	nodamage = TRUE

/obj/projectile/potent_fire/sentinel/scatter
	submunitions = 3
	submunition_dispersion = 50
	submunition_type = /obj/projectile/potent_fire/sentinel
