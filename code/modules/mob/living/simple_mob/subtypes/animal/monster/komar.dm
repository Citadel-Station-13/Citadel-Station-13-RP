/mob/living/simple_mob/animal/monster/komar
	name = "komar"
	desc = "A giant mosquito, at least it looks weak."

	icon = 'icons/mob/monsters/komar.dmi'
	icon_state = "komar"
	icon_living = "komar"
	icon_dead = "komar_dead"

	maxHealth = 150
	health = 150

	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 25

	movement_base_speed = 10 / 3
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee
	iff_factions = MOB_IFF_FACTION_MONSTER_KOMAR
