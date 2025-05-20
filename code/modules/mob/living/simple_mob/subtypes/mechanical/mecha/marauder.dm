// Marauders are even tougher than Durands.

/datum/category_item/catalogue/technology/marauder
	name = "Exosuit - Marauder"
	desc = "Developed by Nanotrasen, the Marauder is the modern descendant of the Durand. Stronger, faster, and more resilient, \
	the Marauder has fully supplanted its predecessor. Deployed by Nanotrasen to the fiercest conflict zones during the Phoron War, \
	Marauders quickly gained a reputation for brutal efficiency. Marauders are fielded by the megacorporation to hot zones across \
	the Frontier to this day. Thanks to its status as a military grade weapons platform and its highly proprietary equipment, \
	the Marauder is generally unavailable to civilians - including low-level Nanotrasen duty stations and allied corporations. \
	Standing at 12'(3m) tall, the Marauder cockpit is complex and spacious enough to grant the pilot a full range of movement \
	within its spherical shell."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/marauder
	name = "marauder"
	desc = "A heavy-duty, combat exosuit, developed after the Durand model. This is rarely found among civilian populations."
	catalogue_data = list(/datum/category_item/catalogue/technology/marauder)
	icon_state = "marauder"
	movement_base_speed = 10 / 5
	wreckage = /obj/structure/loot_pile/mecha/marauder

	maxHealth = 500
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



/datum/category_item/catalogue/technology/seraph
	name = "Exosuit - Seraph"
	desc = "Essentially a Marauder with minor imrprovements, the Seraph combat exosuit is a slight upgrade to its predecessor. \
	Due to the relatively small impact of these changes, the Seraph has not made the Marauder obsolete. Instead Seraph units are \
	generally issued to Nanotrasen paramilitary commanders, where they fill a specialized communications role courtesy of their \
	next-generation communications and electronic warfare suites. Due to the tactical nature of the Seraph's battlefield role, \
	the exosuit is not expected to see combat frequently. In spite of this, the Seraph still fields a combat loadout that enables \
	it to protect itself if attacked unexpectedly."
	value = CATALOGUER_REWARD_HARD

// Slightly stronger, used to allow comdoms to frontline without dying instantly, I guess.
/mob/living/simple_mob/mechanical/mecha/combat/marauder/seraph
	name = "seraph"
	desc = "A heavy-duty, combat/command exosuit. This one is specialized towards housing important commanders such as high-ranking \
	military personnel. It's stronger than the regular Marauder model, but not by much."
	catalogue_data = list(/datum/category_item/catalogue/technology/seraph)
	icon_state = "seraph"
	wreckage = /obj/structure/loot_pile/mecha/marauder/seraph
	health = 550
	legacy_melee_damage_lower = 55 // The real version hits this hard apparently. Ouch.
	legacy_melee_damage_upper = 55

/datum/category_item/catalogue/technology/mauler
	name = "Exosuit - Mauler"
	desc = "In spite of their technological advancement and heavily restricted deployments, Nanotrasen \
	Marauders may sometimes be stolen, salvaged, or illictly purchased from corrupt company officials. These \
	repurposed models are designated Maulers - after the first line produced by the Syndicate during the Phoron \
	War. Functionally identical in terms of armor and armament, Maulers are considerably more rare than the \
	already scarce Marauder, and are considered a black market collectable on par with stolen art."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/marauder/mauler
	name = "mauler"
	desc = "A heavy duty, combat exosuit that is based off of the Marauder model."
	icon_state = "mauler"
	wreckage = /obj/structure/loot_pile/mecha/marauder/mauler
