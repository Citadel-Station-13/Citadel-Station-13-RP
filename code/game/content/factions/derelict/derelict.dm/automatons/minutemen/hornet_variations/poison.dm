/mob/living/simple_mob/mechanical/derelict/minuteman/hornet/poison
	name = "minuteman poison hornet"
	desc = "A medium sized automaton that flies low above the ground. It looks like it can take a few good hits, but most alarmingly is the multitude of pincers and syringes on the tendrils beneath it. You see some sort of liquid in one of its syringes."

	icon_state = "poison_hornet"
	icon_living = "poison_hornet"

	health = 170
	maxHealth = 170
	movement_base_speed = 10 / 3
	hovering = TRUE

	base_attack_cooldown = 12
	legacy_melee_damage_upper = 20
	legacy_melee_damage_lower = 20


	poison_type = "expired_medicine"
	poison_chance = 100
	poison_per_bite = 2
