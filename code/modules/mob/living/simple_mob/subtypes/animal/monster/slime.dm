/mob/living/simple_mob/animal/monster/slime
	name = "slime"
	desc = "A compacted ball of goo which somehow moves on its own."
	description_info = "Kinetic energy probably won't do anything to its goo.. Maybe energy?"

	icon = 'icons/mob/monsters/slime.dmi'
	icon_state = "slime"
	icon_living = "slime"
	icon_dead = "slime_dead"

	maxHealth = 250
	health = 250
	armor_legacy_mob = list(
			"melee"		= 100,
			"bullet"	= 100,
			"laser"		= -30,
			"energy"	= -30,
			"bomb"		= 100,
			"bio"		= 100,
			"rad"		= 100
			)

	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 25

	movement_base_speed = 10 / 6
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee
	iff_factions = MOB_IFF_FACTION_MONSTER_SLIME
