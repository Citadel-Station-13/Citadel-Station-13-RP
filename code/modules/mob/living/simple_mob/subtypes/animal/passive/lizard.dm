/datum/category_item/catalogue/fauna/lizard
	name = "Lizard"
	desc = "A reptile common on Earth, lizards come in a variety \
	of shapes, sizes, and colorations. Popular as pets due to their \
	easy maintenance, these creatures are able to breed quickly, and \
	are now considered a relatively harmless pest across the Frontier."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/passive/lizard
	name = "lizard"
	desc = "A cute, tiny lizard."
	tt_desc = "E Anolis cuvieri"
	catalogue_data = list(/datum/category_item/catalogue/fauna/lizard)

	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard_dead"

	health = 5
	maxHealth = 5
	mob_size = MOB_MINISCULE

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"

	attacktext = list("bitten")
	melee_damage_lower = 1
	melee_damage_upper = 2

	speak_emote = list("hisses")

	say_list_type = /datum/say_list/lizard

//Randomization Code
/mob/living/simple_mob/animal/passive/lizard/Initialize()
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

/mob/living/simple_mob/animal/passive/lizard/large
	desc = "A cute, big lizard."
	maxHealth = 20
	health = 20

	melee_damage_lower = 5
	melee_damage_upper = 15

	attack_sharp = TRUE

	mod_min = 80
	mod_max = 200

/mob/living/simple_mob/animal/passive/lizard/large/defensive
	maxHealth = 30
	health = 30

	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative
