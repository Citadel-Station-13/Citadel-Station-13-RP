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
	movement_works_in_space = TRUE

	make_shield_comp = TRUE
	make_shield_comp_health = 250
	make_shield_comp_recharge_delay = 7 SECONDS
	make_shield_comp_recharge_rate = 30
	make_shield_comp_recharge_rebuild_rate = 30
	make_shield_comp_recharge_rebuild_restore_ratio = 0
	make_shield_comp_pattern = /datum/directional_shield_pattern/square/r_3x3
	make_shield_comp_color_full = "#808080"
	make_shield_comp_color_depleted = "#202020"

/mob/living/simple_mob/mechanical/sentinel/death()
	..(null,"suddenly crashes to the ground, translucent blue blood leaking from a broken thruster.")
