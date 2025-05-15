// Gygaxes are tough but also fast.
// Their AI, unlike most, will advance towards their target instead of remaining in place.

/datum/category_item/catalogue/technology/gygax
	name = "Exosuit - Gygax"
	desc = "The Gygax is a relatively modern exosuit designed for agility and speed without sacrificing durability. \
	These traits have made the Gygax fairly popular among well funded private and corporate security forces. The Gygax \
	features a bespoke actuator assembly that grants the exosuit short-term bursts of unparalleled speed. Consequently, \
	the strain this assembly puts on the exosuit causes damage the unit's structural integrity. In spite of the drawbacks, \
	this feature is frequently utilized by those who require the ability to rapidly respond to conflict. 10'(3m) tall and \
	rotund, the Gygax's cockpit is fully enclosed and protected by the design's diamond-weave armor plating."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/gygax
	name = "gygax"
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	catalogue_data = list(/datum/category_item/catalogue/technology/gygax)
	icon_state = "gygax"
	movement_base_speed = 6.66
	wreckage = /obj/structure/loot_pile/mecha/gygax

	maxHealth = 300
	armor_legacy_mob = list(
				"melee"		= 25,
				"bullet"	= 20,
				"laser"		= 30,
				"energy"	= 15,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	projectiletype = /obj/projectile/beam/midlaser

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/intentional/adv_dark_gygax

/mob/living/simple_mob/mechanical/mecha/combat/gygax/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged // Carries a pistol.


// A stronger variant.

/datum/category_item/catalogue/technology/dark_gygax
	name = "Exosuit - Dark Gygax"
	desc = "This variant of the standard Gygax is colloquially referred to as the 'Dark Gygax', on account of the exotic \
	materials used in its construction. The standard Gygax's diamond-weave armor system is augmented with depleted morphium, \
	lending it a darker and marginally more sinister hue. Simultaneously, this upgrade grants the Dark Gygax considerably more \
	resilience without sacrificing the standard model's agility or speed. Due to the gross expenditure required to fabricate a \
	Dark Gygax's armor plating, these platforms are exceedingly rare. Most security forces are content with the protection and \
	utility of the standard Gygax, making this upgrade appear unnecessary. However, the Dark Gygax is often sought out by \
	high-tier asset protection teams and paramilitary outfits."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/gygax/dark
	name = "dark gygax"
	desc = "A significantly upgraded Gygax security mech, often utilized by corporate asset protection teams and PMCs."
	catalogue_data = list(/datum/category_item/catalogue/technology/dark_gygax)
	icon_state = "darkgygax"
	wreckage = /obj/structure/loot_pile/mecha/gygax/dark

	maxHealth = 400
	deflect_chance = 25
	has_repair_droid = TRUE
	armor_legacy_mob = list(
				"melee"		= 40,
				"bullet"	= 40,
				"laser"		= 50,
				"energy"	= 35,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)

/mob/living/simple_mob/mechanical/mecha/combat/gygax/medgax
	name = "medgax"
	desc = "An unorthodox fusion of the Gygax and Odysseus exosuits, this one is fast, sturdy, and carries a wide array of potent chemicals and delivery mechanisms. The doctor is in!"
	icon_state = "medgax"
	wreckage = /obj/structure/loot_pile/mecha/gygax/medgax
