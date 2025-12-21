/mob/living/simple_mob/mechanical/derelict/minuteman/dragonfly/flame
	name = "minuteman incendiary dragonfly"
	desc = "A lithe hovering automaton. It sports an array of mechanical 'wings', which seems to allow it greater mobility. This one reeks of smoke and fire."

	icon_state = "flame_dragonfly"
	icon_living = "flame_dragonfly"

	health = 200
	maxHealth = 200
	movement_base_speed = 10 / 3
	hovering = TRUE
	evasion = 20


	base_attack_cooldown = 40
	projectiletype = /obj/projectile/potent_fire/sentinel
	legacy_melee_damage_upper = 15
	legacy_melee_damage_lower = 15


	ai_holder_type = /datum/ai_holder/polaris/hostile/ranged/robust


	var/poison_type = "thermite_v"
	var/poison_chance = 100
	var/poison_per_bite = 3
