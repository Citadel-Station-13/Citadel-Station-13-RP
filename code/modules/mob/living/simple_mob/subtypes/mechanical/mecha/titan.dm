/datum/category_item/catalogue/technology/titan
	name = "Alien Machine - Titan"
	desc = "We do not know much about the Titan. Currently, they were just rumours and tales of colonist, with NT being the first to confirm their existance. \
	8 meters tall, they are it seems the still functionning relic of the long gone civilisation of the drifting planet. Combat capable, they are theorised to be very fast when in pristine condition. \
	Very hostile, they make use of giant weapons, and attack anyone on sight."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/mechanical/mecha/combat/titan
	name = "titan"
	desc = "A misterious giant machine patroling the ruins of a long gone civilisation. You might be one in the first person in the galaxy to see it."
	catalogue_data = list(/datum/category_item/catalogue/technology/titan)
	icon = 'icons/obj/vce_asset/vce_mob_titan.dmi'
	icon_state = "base"
	movement_base_speed = 10 / 7
	wreckage = /obj/structure/salvageable/titan_wreck/titan

	maxHealth = 300
	deflect_chance = 25
	sight = SEE_SELF | SEE_MOBS
	armor_legacy_mob = list(
				"melee"		= 50,
				"bullet"	= 55,
				"laser"		= 40,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)
	legacy_melee_damage_lower = 45
	legacy_melee_damage_upper = 45
	base_attack_cooldown = 2 SECONDS

/mob/living/simple_mob/mechanical/mecha/combat/titan/sword
	name = "titan"
	desc = "A misterious giant machine patroling the ruins of a long gone civilisation. You might be one in the first person in the galaxy to see it."
	catalogue_data = list(/datum/category_item/catalogue/technology/titan)
	icon_state = "sword"
	movement_base_speed = 10 / 7
	wreckage = /obj/structure/salvageable/titan_wreck/titan

	maxHealth = 300
	deflect_chance = 25
	sight = SEE_SELF | SEE_MOBS
	armor_legacy_mob = list(
				"melee"		= 50,
				"bullet"	= 55,
				"laser"		= 40,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)
	legacy_melee_damage_lower = 45
	legacy_melee_damage_upper = 45
	base_attack_cooldown = 2 SECONDS

/mob/living/simple_mob/mechanical/mecha/combat/titan/gun/boss
	name = "titan"
	desc = "A misterious giant machine patroling the ruins of a long gone civilisation. You might be one in the first person in the galaxy to see it."
	catalogue_data = list(/datum/category_item/catalogue/technology/titan)
	icon_state = "gun"
	movement_base_speed = 10 / 7
	wreckage = /obj/structure/salvageable/titan_wreck/titan

	maxHealth = 300
	deflect_chance = 25
	sight = SEE_SELF | SEE_MOBS
	armor_legacy_mob = list(
				"melee"		= 50,
				"bullet"	= 55,
				"laser"		= 40,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)
	legacy_melee_damage_lower = 45
	legacy_melee_damage_upper = 45
	base_attack_cooldown = 2 SECONDS
	projectiletype = /obj/projectile/beam/heavylaser


/mob/living/simple_mob/mechanical/mecha/combat/titan/gun/boss1
	name = "Fabric titan"
	desc = "A misterious giant machine patroling the ruins of a long gone civilisation. You might be one in the first person in the galaxy to see it."
	catalogue_data = list(/datum/category_item/catalogue/technology/titan)
	icon_state = "gun"
	movement_base_speed = 10 / 7
	wreckage = /obj/structure/salvageable/titan_wreck/titan
	color = "#1e2f79"

	maxHealth = 400
	deflect_chance = 25
	sight = SEE_SELF | SEE_MOBS
	armor_legacy_mob = list(
				"melee"		= 50,
				"bullet"	= 55,
				"laser"		= 40,
				"energy"	= 30,
				"bomb"		= 30,
				"bio"		= 100,
				"rad"		= 100
				)
	legacy_melee_damage_lower = 45
	legacy_melee_damage_upper = 45
	base_attack_cooldown = 2 SECONDS
	projectiletype = /obj/projectile/beam/heavylaser
