/mob/living/simple_mob/mechanical/derelict/minuteman/dragonfly/ion
	name = "minuteman ionospheric dragonfly"
	desc = "A lithe hovering automaton. It sports an array of mechanical 'wings', which seems to allow it greater mobility. Your electronics are crackling by merely looking at this one."

	icon_state = "ion_dragonfly"
	icon_living = "ion_dragonfly"

	health = 200
	maxHealth = 200
	movement_base_speed = 10 / 3
	hovering = TRUE
	evasion = 20


	base_attack_cooldown = 15
	projectiletype = /obj/projectile/ion/small
	legacy_melee_damage_upper = 15
	legacy_melee_damage_lower = 15


	ai_holder_type = /datum/ai_holder/polaris/hostile/ranged/robust
