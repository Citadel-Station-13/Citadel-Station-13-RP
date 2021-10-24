// Reticent mecha are quick and deadly in melee.

/datum/category_item/catalogue/technology/reticent
	name = "Exosuit - Reticent"

	desc = "During the Melancholy Occupation of 2476 - callously referred to by their opposition as the 'Prank War', the \
	people of Le Rien realized the rapidly widening gulf between their technological advancements and Columbina's. Aiming to \
	prevent another such tragedy from happening again, extensive research was conducted on the H.O.N.K. mecha deployed by \
	the Clowns. Although Silencium bears less technological utility, scientists were able to employ its own unique properties in \
	the Reticent's design. An agile mecha plated in a sturdy layer of Silencium, the Reticent was able to move silently through \
	corridors its bulkier opponent could not. Able to close distance with the more range biased H.O.N.K. mecha, Reticent units \
	deployed to occupied zones quickly cleared out mechanized garrisons. Although formidable, the Reticent suffers from a weak \
	chassis - a byproduct of its maneuverability, and is easily disabled once its dense mineral armor is shattered."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/reticent
	name = "Reticent"
	desc = "Designed in response to the H.O.N.K., Reticent models are close combat powerhouses designed to rapidly and quietly ambush slower foes."
	catalogue_data = list(/datum/category_item/catalogue/technology/reticent)
	icon_state = "reticent"
	movement_cooldown = 0.5
	movement_sound = 'sound/effects/suitstep1.ogg'
	turn_sound = 'sound/effects/suitstep2.ogg'
	melee_attack_delay = 2
	wreckage = /obj/structure/loot_pile/mecha/reticent
	var/obj/item/shield_projector/shields = null

	maxHealth = 180
	armor = list(
				"melee"		= 40,
				"bullet"	= 25,
				"laser"		= 10,
				"energy"	= 15,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

/mob/living/simple_mob/mechanical/mecha/combat/reticent/Initialize(mapload)
	shields = new /obj/item/shield_projector/rectangle/automatic/reticent(src)
	return ..()

/obj/item/shield_projector/rectangle/automatic/reticent
	shield_health = 200
	max_shield_health = 200
	shield_regen_delay = 10 SECONDS
	shield_regen_amount = 10
	size_x = 1
	size_y = 1
	color = "#CFCFCF"
	high_color = "#CFCFCF"
	low_color = "#FFC2C2"

//No Manned variant yet.
/*
/mob/living/simple_mob/mechanical/mecha/combat/reticent/manned
	pilot_type = null
*/

// A stronger variant.

/datum/category_item/catalogue/technology/reticence
	name = "Exosuit - Reticence"

	desc = "After fully repelling the Columbinan occupiers in 2503, Le Rien began to construct powerful defensive \
	lines along their borders. Decades of fighting had provided researchers with plenty of insight into the faults \
	and merits of the Reticent design. Although intent on keeping the model in service, the Silent Council decreed \
	that a new mech platform would need to be developed to bolster their static defensive line. The Reticent was far \
	too fragile for border defense. Returning to more traditional mecha design doctrine, the Reticence is larger, \
	heavier, and more armored than its predecessor. Trading in the Reticent's blinding speed for a more powerful \
	shielding system and significant improvements in Silencium armor placement, the Reticence is still able to close \
	the gap and deliver close-range punishment to any who dare violate Le Rien's borders."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/reticent/reticence
	name = "Reticence"
	desc = "The current flagship mecha of Le Rien. The Reticence trades some speed for durability, but remains formidable. It is not commercially available."
	catalogue_data = list(/datum/category_item/catalogue/technology/reticence)
	icon_state = "reticence"
	movement_cooldown = 1
	melee_attack_delay = 0
	wreckage = /obj/structure/loot_pile/mecha/reticent/reticence

	maxHealth = 350
	deflect_chance = 40
	has_repair_droid = TRUE
	armor = list(
				"melee"		= 60,
				"bullet"	= 40,
				"laser"		= 50,
				"energy"	= 35,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)

/mob/living/simple_mob/mechanical/mecha/combat/reticent/reticence/Initialize(mapload)
	shields = new /obj/item/shield_projector/rectangle/automatic/reticence(src)
	return ..()

/obj/item/shield_projector/rectangle/automatic/reticence
	shield_health = 300
	max_shield_health = 300
	shield_regen_delay = 10 SECONDS
	shield_regen_amount = 10
	size_x = 1
	size_y = 1
	color = "#CFCFCF"
	high_color = "#CFCFCF"
	low_color = "#FFC2C2"
