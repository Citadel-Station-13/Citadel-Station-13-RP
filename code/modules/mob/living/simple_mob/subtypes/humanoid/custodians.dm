/mob/living/simple_mob/humanoid/unnamed
	name = "Strange Being"
	desc = "A strange humanoid creature with no known databse entries."
	tt_desc = "???"
	icon_state = "piratemelee"
	icon_living = "piratemelee"
	icon_dead = "piratemelee_dead"

	faction = "remnant"

	response_help = "touches"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 10
	melee_damage_lower = 40
	melee_damage_upper = 55
	attack_armor_pen = 50
	attack_sharp = 1
	attack_edge = 1

	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	loot_list = list()

	corpse = /obj/effect/landmark/mobcorpse/pirate