/mob/living/simple_mob/animal/monster/bug
	name = "bug"
	desc = "An oversized insect with sharp claws."

	icon = 'icons/mob/monsters/bug.dmi'
	icon_state = "bug"
	icon_living = "bug"
	icon_dead = "bug_dead"

	maxHealth = 100
	health = 100

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 15

	movement_base_speed = 10 / 3
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/retaliate/cooperative
	iff_factions = MOB_IFF_FACTION_MONSTER_WOLF
