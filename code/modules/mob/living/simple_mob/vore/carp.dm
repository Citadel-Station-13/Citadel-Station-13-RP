/mob/living/simple_mob/animal/space/carp/large/huge
	name = "great white carp"
	desc = "You're going to need a bigger ship."
	icon = 'icons/mob/vore64x64.dmi'
	icon_dead = "megacarp-dead"
	icon_living = "megacarp"
	icon_state = "megacarp"

	maxHealth = 600 // Boss
	health = 600
	movement_cooldown = 3

	meat_amount = 10

	melee_damage_lower = 10
	melee_damage_upper = 25
	old_x = -16
	old_y = -16
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16
	vore_capacity = 2

// Activate Noms!
/mob/living/simple_mob/animal/space/carp/large
	icon = 'icons/mob/vore64x64.dmi'
	vore_active = 1
	vore_pounce_chance = 50
	vore_capacity = 1
	vore_max_size = RESIZE_HUGE
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/carp/pike
	name = "space pike"
	desc = "A bigger, angrier cousin of the space carp."
	icon = 'icons/mob/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"

	maxHealth = 150
	health = 150
	movement_cooldown = 0

	mob_size = MOB_LARGE

	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 25

	meat_amount = 10

	old_x = -16
	pixel_x = -16

	vore_icons = 0 //No custom icons yet

/mob/living/simple_mob/animal/space/carp/pike/weak
	maxHealth = 75
	health = 75

/mob/living/simple_mob/animal/space/carp/strong
	maxHealth = 50
	health = 50
