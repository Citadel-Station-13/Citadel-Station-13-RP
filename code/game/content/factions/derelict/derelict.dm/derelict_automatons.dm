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
	movement_base_speed = 10 / 5
	hovering = TRUE

	base_attack_cooldown = 12
	projectiletype = /obj/projectile/beam/darkmatter
	projectilesound = 'sound/weapons/marauder.ogg'

	response_help = "shoves aside"
	response_disarm = "forces aside"
	response_harm = "pulverizes"

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting/threatening

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
