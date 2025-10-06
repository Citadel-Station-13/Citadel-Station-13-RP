// Feral felines that stalk areas, searching for their next prey. Mainly ambush predators that work alone.


/mob/living/simple_mob/animal/monster/bobcat
	name = "bobcat"
	desc = "A feral feline sporting dark brown fur, sharp teeth and even sharper claws."

	icon = 'icons/mob/monsters/bobcat.dmi'
	icon_state = "bobcat"
	icon_living = "bobcat"
	icon_dead = "bobcat_dead"
	base_pixel_y = -3

	maxHealth = 200
	health = 200
	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 20

	movement_base_speed = 10 / 3
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive
	iff_factions = MOB_IFF_FACTION_MONSTER_BOBCAT
