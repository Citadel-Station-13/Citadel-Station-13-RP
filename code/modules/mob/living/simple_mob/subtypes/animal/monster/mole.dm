/mob/living/simple_mob/animal/monster/mole
	name = "mole"
	desc = "A massive mole like creature."

	icon = 'icons/mob/monsters/mole.dmi'
	icon_state = "mole"
	icon_living = "mole"
	icon_dead = "mole_dead"
	base_pixel_x = -23
	base_pixel_y = -7


	maxHealth = 300
	health = 300

	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 25

	movement_base_speed = 10 / 4
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/retaliate/cooperative
	iff_factions = MOB_IFF_FACTION_MONSTER_MOLE
