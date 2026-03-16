/mob/living/simple_mob/mechanical/derelict/minuteman/dragonfly/sniper
	name = "minuteman marksman dragonfly"
	desc = "A lithe hovering automaton. It sports an array of mechanical 'wings', which seems to allow it greater mobility. This one appears fitted with some sort of long-ranged energy weapon."

	icon_state = "sniper_dragonfly"
	icon_living = "sniper_dragonfly"

	health = 200
	maxHealth = 200
	movement_base_speed = 10 / 4
	hovering = TRUE
	evasion = 20


	base_attack_cooldown = 20
	projectiletype = /obj/projectile/beam/darkmatter/sentinel
	legacy_melee_damage_upper = 5
	legacy_melee_damage_lower = 5


	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/sniper
