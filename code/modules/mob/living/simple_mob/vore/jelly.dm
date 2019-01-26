/mob/living/simple_mob/animal/jelly
	name = "jelly blob"
	desc = "Some sort of undulating blob of slime!"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "jelly_dead"
	icon_living = "jelly"
	icon_state = "jelly"

	faction = "virgo2"
	maxHealth = 50
	health = 50

	melee_damage_lower = 5
	melee_damage_upper = 15

	vore_active = 1
	vore_pounce_chance = 0
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS // Hungry little bastards.
	ai_holder_type = /datum/ai_holder/simple_mob
	say_list_type = /datum/say_list/jelly

/datum/say_list/jelly
	emote_hear = list("squishes","spluts","splorts","sqrshes","makes slime noises")
	emote_see = list("undulates quietly")
