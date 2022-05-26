/datum/category_item/catalogue/fauna/panther
	name = "Panther"
	desc = "Sometimes imported to the Frontier by exotic animal collectors, \
	Panthers are big cats native to Earth. Driven to near extinction after \
	the Final War, they have since seen a resurgence in population due to cloning \
	and environmentalist initiatives."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/aggressive/panther
	name = "panther"
	desc = "Runtime's larger, less cuddly cousin."
	tt_desc = "Panthera pardus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/panther)

	icon_state = "panther"
	icon_living = "panther"
	icon_dead = "panther-dead"
	icon = 'icons/mob/vore64x64.dmi'

	faction = "panther"
	maxHealth = 200
	health = 200
	randomized = TRUE
	movement_cooldown = 4

	melee_damage_lower = 5
	melee_damage_upper = 15
	attack_sharp = TRUE

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_y = 12

	say_list_type = /datum/say_list/panther
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

// Activate Noms!
/mob/living/simple_mob/vore/aggressive/panther
	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 10
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/datum/say_list/panther
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_hear = list("rawrs","rumbles","rowls","growls","roars")
	emote_see = list("stares ferociously", "snarls")
