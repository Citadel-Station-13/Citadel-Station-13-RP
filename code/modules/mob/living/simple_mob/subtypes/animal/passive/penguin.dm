/mob/living/simple_mob/animal/passive/penguin
	name = "penguin"
	desc = "An ungainly, waddling, cute, and VERY well-dressed bird."
	tt_desc = "Aptenodytes forsteri"
	icon_state = "penguin_old"
	icon_living = "penguin_old"
	icon_dead = "penguin_old_dead"

	maxHealth = 20
	health = 20
	minbodytemp = 175 // Same as Sif mobs.

	response_help  = "pets"
	response_disarm = "pushes aside"
	response_harm   = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attacktext = list("pecked")

	has_langs = list("Bird")

/mob/living/simple_mob/animal/passive/penguin/tux
	name = "Tux"
	desc = "A penguin that has been known to associate with gnus."
	speak_emote = list("interjects")

/mob/living/simple_mob/animal/passive/penguin/baby
	name = "baby penguin"
	desc = "An emperor penguin's chick. It is iconic, and what most will associate with the image of a baby penguin. It's small and fluffy."
	icon_state = "baby_penguin"
	icon_living = "baby_penguin"
	icon_dead = "baby_penguin_dead"

/mob/living/simple_mob/animal/passive/penguin/emperor
	name = "emperor penguin"
	desc = "Of all species of penguin, this one is the greatest known living species. It stands proudly in it's rule as emperor."
	icon_state = "emperor_penguin"
	icon_living = "emperor_penguin"
	icon_dead = "emperor_penguin_dead"