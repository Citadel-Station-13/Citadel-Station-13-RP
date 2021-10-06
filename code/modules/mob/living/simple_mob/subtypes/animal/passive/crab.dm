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
    var/mod = rand(50,150)/100
    size_multiplier = mod
    maxHealth = round(20*mod)
    health = round(20*mod)
    melee_damage_lower = round(5*mod)
    melee_damage_upper = round(5*mod)
    movement_cooldown = round(5*mod)
    update_icons()

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_mob/animal/passive/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"

//Unrandomized pet
/mob/living/simple_mob/animal/passive/crab/Coffee/Initialize()
    . = ..()
    size_multiplier = 1
    maxHealth = 20
    health = 20
    melee_damage_lower = 5
    melee_damage_upper = 5
    movement_cooldown = 5
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

	catalogue_data = list(/datum/category_item/catalogue/fauna/sif_crab)

/*/mob/living/simple_mob/animal/passive/crab/sif/Initialize(mapload)
	. = ..()
	adjust_scale(rand(5,15) / 10)*/

// Meat!

/obj/item/reagent_containers/food/snacks/meat/crab
	name = "meat"
	desc = "A chunk of meat."
	icon_state = "crustacean-meat"
