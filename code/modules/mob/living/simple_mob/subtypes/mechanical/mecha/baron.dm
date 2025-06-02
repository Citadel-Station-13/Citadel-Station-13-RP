// Pirate Baron

/datum/category_item/catalogue/technology/baron/pirate
	name = "Fighter - Baron"
	desc = "This is a small space fightercraft that has an arrowhead design. Can hold up to one pilot. \
	Unlike some fighters, this one is not designed for atmospheric operation, and is only capable of performing \
	maneuvers in the vacuum of space. Attempting flight while in an atmosphere is not recommended. Those one are used by pirates."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/fighter/baron
	name = "pirate baron"
	desc = "A pirate used space superiority fighter, one-seater. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron"
	color = "#5a4f2e"
	movement_base_speed = 10 / 1
	wreckage = /obj/effect/decal/mecha_wreckage/baron
	catalogue_data = list(/datum/category_item/catalogue/technology/baron/pirate)

	maxHealth = 200
	deflect_chance = 30
	armor_legacy_mob = list(
				"melee"		= 30,
				"bullet"	= 30,
				"laser"		= 30,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)
	projectiletype = /obj/projectile/bullet/pistol/medium
	base_attack_cooldown = 0.5 SECONDS
	needs_reload = TRUE
	reload_max = 40
	reload_time = 3

/mob/living/simple_mob/mechanical/mecha/fighter/baron/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged/space
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged/surpressor
