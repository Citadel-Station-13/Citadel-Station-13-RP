/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/venom
	name = "minuteman venom hornet"
	desc = "A medium sized automaton that flies low above the ground. It looks like it can take a few good hits, but most alarmingly is the multitude of pincers and syringes on the tendrils beneath it. Its frame reeks of pepper and fire."

	icon_state = "venom_hornet"
	icon_living = "venom_hornet"

	health = 170
	maxHealth = 170
	movement_base_speed = 10 / 3
	hovering = TRUE

	base_attack_cooldown = 12
	legacy_melee_damage_upper = 20
	legacy_melee_damage_lower = 20


	poison_type = "condensedcapsaicin_v"
	poison_chance = 100
	poison_per_bite = 10
