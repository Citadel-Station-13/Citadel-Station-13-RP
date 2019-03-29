/mob/living/simple_animal/hostile/wolf
	name = "grey wolf"
	desc = "My, what big jaws it has!"
	tt_desc = "Canis lupus"
	icon = 'icons/mob/vore.dmi'
	icon_dead = "wolf-dead"
	icon_living = "wolf"
	icon_state = "wolf"

	speed = 3 //cit change, saviks have 2 speed and they can catch up to anyone that dosnt have haste and major hearty, nerfed from 5 to 3 with the addition of snowfields.

	run_at_them = 0
	cooperative = 1
	investigates = 1
	returns_home = 1
	reacts = 1

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 25

	minbodytemp = 200

// Activate Noms!
/mob/living/simple_animal/hostile/wolf
	vore_active = 1
	vore_icons = SA_ICON_LIVING
