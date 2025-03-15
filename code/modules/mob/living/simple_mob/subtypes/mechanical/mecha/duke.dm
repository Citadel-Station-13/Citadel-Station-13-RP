/datum/category_item/catalogue/technology/duke/pirate
	name = "Fighter - Duke"
	desc = "The Duke Heavy Fighter is designed and manufactured by Hephaestus Industries as a bulky craft built to punch above its weight. Primarily armed with missiles, bombs, or similar large payloads, this fighter packs a punch against most at the cost of room for minimul hull modifications, which is almost always reserved for much-needed armor inserts instead of a shield. It's incapable of atmospheric flight. Those one are used by pirates."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/fighter/duke
	name = "pirate duke"
	desc = "A pirate used space heavy fighter, one-seater. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "duke_cw"
	movement_cooldown = 1.5
	wreckage = /obj/effect/decal/mecha_wreckage/duke
	catalogue_data = list(/datum/category_item/catalogue/technology/duke/pirate)

	maxHealth = 250
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
	projectiletype = /obj/projectile/beam
	base_attack_cooldown = 0.7 SECONDS
	needs_reload = TRUE
	reload_max = 30
	reload_time = 5

/mob/living/simple_mob/mechanical/mecha/fighter/duke/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged/space
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged/surpressor
