/mob/living/simple_mob/mechanical/derelict/broodmother
	name = "broodmother"
	desc = "A massive machine that is covered in armor plating. Despite this, it appears to float above the terrain with ease. You can see multiple ports and what appears to be some sort of launcher affixed to its back plating."

	icon = 'code/game/content/factions/derelict/derelict.dmi/automatons/broodmother.dmi'
	icon_state = "broodmother"
	icon_living = "broodmother"
	icon_dead = null
	icon_scale_x = 1.2
	icon_scale_y = 1.2
	base_pixel_x = -8

	iff_factions = MOB_IFF_FACTION_DERELICT_AUTOMATONS
	health = 600
	maxHealth = 600
	armor_legacy_mob = list(
		"melee" = 20,
		"bullet" = 30,
		"laser" = 25,
		"energy" = 30,
		"bomb" = 50,
		"bio" = 100,
		"rad" = 100,
	)
	self_rejuvination = TRUE
	movement_base_speed = 10 / 5
	hovering = TRUE

	base_attack_cooldown = 30

	response_help = "shoves aside"
	response_disarm = "forces aside"
	response_harm = "smashes into"

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/intentional/adv_dark_gygax
	special_attack_min_range = 1
	special_attack_max_range = 7
	special_attack_cooldown = 1 SECONDS

	var/obj/item/shield_projector/shields = null

	var/exploded = FALSE
	var/explosion_dev_range		= 2
	var/explosion_heavy_range	= 5
	var/explosion_light_range	= 10
	var/explosion_flash_range	= 20
	var/explosion_delay_lower	= 10 SECONDS
	var/explosion_delay_upper	= 10 SECONDS


/mob/living/simple_mob/mechanical/derelict/broodmother/do_special_attack(atom/A)
	. = TRUE
	switch(a_intent)
		if(INTENT_HELP) // Wasp Deployment
			wasp(A)
		if(INTENT_DISARM) // Hornet Deployment
			hornet(A)
		if(INTENT_GRAB) // Dragonfly Deployment
			dragonfly(A)
		if(INTENT_HARM) // Mantis Deployment
			mantis(A)


/mob/living/simple_mob/mechanical/derelict/broodmother/proc/wasp(atom/target)
	projectiletype = /obj/projectile/arc/broodmother/deployment/wasp

/mob/living/simple_mob/mechanical/derelict/broodmother/proc/hornet(atom/target)
	projectiletype = /obj/projectile/arc/broodmother/deployment/hornet

/mob/living/simple_mob/mechanical/derelict/broodmother/proc/dragonfly(atom/target)
	projectiletype = /obj/projectile/arc/broodmother/deployment/dragonfly

/mob/living/simple_mob/mechanical/derelict/broodmother/proc/mantis(atom/target)
	projectiletype = /obj/projectile/arc/broodmother/deployment/mantis


/mob/living/simple_mob/mechanical/derelict/broodmother/proc/baneling()
	var/delay = rand(explosion_delay_lower, explosion_delay_upper)
	spawn(0)
		// Flash black and red as a warning.
		for(var/i = 1 to delay)
			if(i % 2 == 0)
				color = "#810a0a"
			else
				color = "#3d1414"
			sleep(1)

	spawn(delay)
		// The actual boom.
		if(src && !exploded)
			visible_message(span_colossus("\The [src] violently explodes in a flash of blinding energy!"))
			exploded = TRUE
			explosion(src.loc, explosion_dev_range, explosion_heavy_range, explosion_light_range, explosion_flash_range)

		spawn(0 SECOND)
			qdel(src)

/mob/living/simple_mob/mechanical/derelict/broodmother/Initialize(mapload)
	shields = new /obj/item/shield_projector/rectangle/automatic/advanced(src)
	return ..()

/mob/living/simple_mob/mechanical/derelict/broodmother/Destroy()
	QDEL_NULL(shields)
	return ..()

/mob/living/simple_mob/mechanical/derelict/broodmother/death()
    visible_message(span_colossus("\The [src] emits a agonized shriek as its reactor begins to overload! GET BACK!"))
    baneling()

/mob/living/simple_mob/mechanical/derelict/broodmother/Process_Spacemove(var/check_drift = 0)
	return TRUE


	// DEPLOYMENT PROJECTILES //

/obj/projectile/arc/broodmother/deployment/wasp
	name = "deployment medium"
	icon_state = "particle"
	damage_force = 0
	nodamage = 1
	var/wasp

/obj/projectile/arc/broodmother/deployment/wasp/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	..()
	wasp = new /mob/living/simple_mob/mechanical/derelict/minuteman/wasp(src.loc)


/obj/projectile/arc/broodmother/deployment/hornet
	name = "deployment medium"
	icon_state = "nuclear_particle"
	damage_force = 0
	nodamage = 1
	var/hornet

/obj/projectile/arc/broodmother/deployment/hornet/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	..()
	var/hornet_type = pick(/mob/living/simple_mob/mechanical/derelict/minuteman/hornet,
	/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/irradiator,
	/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/neurophage,
	/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/thermite,
	/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/poison,
	/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/venom)
	hornet = new hornet_type(src.loc)


/obj/projectile/arc/broodmother/deployment/dragonfly
	name = "deployment medium"
	icon_state = "pulse0"
	damage_force = 0
	nodamage = 1
	var/dragonfly

/obj/projectile/arc/broodmother/deployment/dragonfly/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	..()
	var/dragonfly_type = pick(/mob/living/simple_mob/mechanical/derelict/minuteman/hornet,
	/mob/living/simple_mob/mechanical/derelict/minuteman/dragonfly,
	/mob/living/simple_mob/mechanical/derelict/minuteman/dragonfly/flame,
	/mob/living/simple_mob/mechanical/derelict/minuteman/dragonfly/ion,
	/mob/living/simple_mob/mechanical/derelict/minuteman/dragonfly/sniper)
	dragonfly = new dragonfly_type(src.loc)


/obj/projectile/arc/broodmother/deployment/mantis
	name = "deployment medium"
	icon_state = "particle-heavy"
	damage_force = 0
	nodamage = 1
	var/mantis

/obj/projectile/arc/broodmother/deployment/mantis/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	..()
	mantis = new /mob/living/simple_mob/mechanical/derelict/minuteman/mantis(src.loc)
