////////////////////////////
//		Harvester
////////////////////////////

/datum/category_item/catalogue/fauna/construct/harvester
	name = "Constructs - Harvester"
	desc = "Harvesters are incredibly rare Construct forms, observed \
	only during the Blood Cult raid on the NDV Marksman. Fragile, but \
	quick, Harvesters were named so due to their tendency to pull injured \
	combatants back behind their own lines. Many victims who were carried \
	off in this way were never recovered: their ultimate fate is a mystery, \
	though they are presumed dead."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	construct_type = "harvester"
	desc = "A tendril-laden construct piloted by a chained mind."
	icon_state = "harvester"
	icon_living = "harvester"
	maxHealth = 100
	health = 100
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("violently stabbed")
	friendly = list("caresses")
	movement_cooldown = 0
	catalogue_data = list(/datum/category_item/catalogue/fauna/construct/harvester)

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	//	environment_smash = 1	// Whatever this gets renamed to, Harvesters need to break things

	attack_sound = 'sound/weapons/pierce.ogg'

	armor = list(
				"melee" = 10,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 20,
				"bomb" = 20,
				"bio" = 100,
				"rad" = 100)

	construct_spells = list(
			/spell/aoe_turf/knock/harvester,
			/spell/targeted/construct_advanced/inversion_beam,
			/spell/targeted/construct_advanced/agonizing_sphere,
			/spell/rune_write
		)

/mob/living/simple_mob/construct/harvester/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura/strong)

////////////////////////////
//		Greater Harvester
////////////////////////////

/mob/living/simple_mob/construct/harvester/greater
	name = "Greater Harvester"
	real_name = "Chosen"
	construct_type = "Chosen"
	desc = "A infanthomable mass of tentacles and claws ripping and tearing through all that oppose it."
	icon_state = "chosen"
	icon_living = "chosen"
	maxHealth = 100
	health = 100
	melee_damage_lower = 40 //Glass Cannon Mini-Boss/Semi-Boss large. Few hits is enough to end you.
	melee_damage_upper = 50
	attack_armor_pen = 60 //No Armor Shall Save you
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("violently stabbed")
	friendly = list("caresses")
	movement_cooldown = 0

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	//	environment_smash = 1	// Whatever this gets renamed to, Harvesters need to break things

	attack_sound = 'sound/weapons/pierce.ogg'
