/datum/category_item/catalogue/fauna/frog
	name = "Giant Frog"
	desc = "Another example of genetic engineering gone right - mostly - the Giant Frog \
	is an upscaled amphibian originally imported from Earth. Although questions abound \
	regarding why one might need to produce genetically altered giant frogs, most Scientists \
	are simply happy the DNA wasn't added to fossilized dinosaur eggs."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/aggressive/frog
	name = "giant frog"
	desc = "You've heard of having a frog in your throat, now get ready for the reverse."
	tt_desc = "Anura gigantus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/frog)

	icon_dead = "frog-dead"
	icon_living = "frog"
	icon_state = "frog"
	icon = 'icons/mob/vore.dmi'

	randomized = TRUE

	movement_cooldown = 4 //fast as fucc boie.

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 12

	ai_holder_type = /datum/ai_holder/simple_mob/melee

// Pepe is love, not hate.
/mob/living/simple_mob/vore/aggressive/frog/Initialize(mapload)
	. = ..()
	if(rand(1,1000000) == 1)
		name = "rare Pepe"
		desc = "You found a rare Pepe. Screenshot for good luck."
		mod_min = 100
		mod_max = 150

// Activate Noms!
/mob/living/simple_mob/vore/aggressive/frog
	vore_active = 1
	vore_pounce_chance = 50
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/vore/aggressive/frog/space
	name = "space frog"

	//Space frog can hold its breath or whatever
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
