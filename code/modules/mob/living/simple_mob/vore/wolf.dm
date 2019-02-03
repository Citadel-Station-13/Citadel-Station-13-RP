/mob/living/simple_mob/animal/wolf
	name = "grey wolf"
	desc = "My, what big jaws it has!"
	tt_desc = "Canis lupus"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "wolf-dead"
	icon_living = "wolf"
	icon_state = "wolf"

	movement_cooldown = 3

	ai_holder_type = /datum/ai_holder/simple_mob/wolf

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 25

	minbodytemp = 200

	vore_active = 1
	vore_icons = SA_ICON_LIVING

/datum/ai_holder/simple_mob/wolf
	cooperative = TRUE
