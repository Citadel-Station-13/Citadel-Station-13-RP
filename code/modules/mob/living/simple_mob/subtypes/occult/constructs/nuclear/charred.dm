////////////////////////////
//		Charred
////////////////////////////

/datum/category_item/catalogue/fauna/nuclear_spirits/charred
	name = "Paranatural Entity - Charred Runner"
	desc = "A paranatural creature resembling a charred corpse. \
	The carbonized 'flesh' of this creature is adept at absorbing \
	energy but vulnerable to kinectic force. Lacking any innate \
	sense of self preservation these creatures throw themselves at \
	their attackers with no apparent regard for their own lives \
	leaving behind their charred shell as they expire."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/construct/nuclear/charred
	name = "Charred Runner"
	real_name = "Charred Runner"
	desc = "A charred corpse: animated and coming right for you."
	icon_state = "charred"
	icon_living = "charred"
	icon_dead = "charred_dead"
	maxHealth = 100
	health = 100
	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10
	attacktext = list("slapped")
	friendly = list("caresses")
	movement_base_speed = 6.66
	catalogue_data = list(/datum/category_item/catalogue/fauna/nuclear_spirits/charred)

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

	armor_legacy_mob = list(
				"melee" = -50,
				"bullet" = 0,
				"laser" = 50,
				"energy" = 50,
				"bomb" = -50,
				"bio" = 100,
				"rad" = 100)
