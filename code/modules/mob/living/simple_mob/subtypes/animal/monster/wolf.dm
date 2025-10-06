/mob/living/simple_mob/animal/monster/wolf
	name = "wolf"
	desc = "A wolf with dark grey fur and very sharp teeth."

	icon = 'icons/mob/monsters/wolf.dmi'
	icon_state = "wolf"
	icon_living = "wolf"
	icon_dead = "wolf_dead"

	maxHealth = 250
	health = 250

	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 30

	movement_base_speed = 10 / 3
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive
	iff_factions = MOB_IFF_FACTION_MONSTER_WOLF
