//Look Sir, free crabs!
/datum/category_item/catalogue/fauna/crab
	name = "Crab"
	desc = "A popular curstacean originating from Old Earth's oceans, the \
	crab is enjoyed for its rich meat. The price of importing live crabs has ensured \
	their scarcity, resulting in them being considered a Galactic delicacy."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/passive/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	tt_desc = "E Cancer bellianus"
	faction = "crabs"
	catalogue_data = list(/datum/category_item/catalogue/fauna/crab)

	icon_state = "crab"
	icon_living = "crab"
	icon_dead = "crab_dead"

	mob_size = MOB_SMALL

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	friendly = "pinches"

	meat_type = /obj/item/reagent_containers/food/snacks/meat/crab

	say_list_type = /datum/say_list/crab

//Randomization Code
/mob/living/simple_mob/animal/passive/crab/Initialize()
    . = ..()
    var/mod = rand(mod_min,mod_max)/100
    size_multiplier = mod
    maxHealth = round(maxHealth*mod)
    health = round(health*mod)
    melee_damage_lower = round(melee_damage_lower*mod)
    melee_damage_upper = round(melee_damage_upper*mod)
    movement_cooldown = round(movement_cooldown*mod)
    meat_amount = round(meat_amount*mod)
    update_icons()

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_mob/animal/passive/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"

//Unrandom Pet
/mob/living/simple_mob/animal/passive/chicken/Initialize()
    . = ..()
    size_multiplier = 1
    maxHealth = maxHealth
    health = health
    melee_damage_lower = melee_damage_lower
    melee_damage_upper = melee_damage_upper
    movement_cooldown = movement_cooldown
    meat_amount = meat_amount
    update_icons()
// Sif!

/datum/category_item/catalogue/fauna/sif_crab
	name = "Sivian Fauna - Shelf Crab"
	desc = "Classification: S Ocypode glacian\
	<br><br>\
	A small crustacean sometimes considered a pest to Sivian fisheries, \
	as the creatures often tend to ignore non-native fish species when feeding. This \
	results in an unfortunate advantage for invasive species. \
	<br>\
	Otherwise, these animals are enjoyed as a reliable source of high-grade meat."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/passive/crab/sif
	icon = 'icons/mob/fish.dmi'
	tt_desc = "S Ocypode glacian"

	//Translating to new system.
	mod_min = 50
	mod_max = 150

	catalogue_data = list(/datum/category_item/catalogue/fauna/sif_crab)

// Meat!

/obj/item/reagent_containers/food/snacks/meat/crab
	name = "meat"
	desc = "A chunk of meat."
	icon_state = "crustacean-meat"
