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

	iff_factions = MOB_IFF_FACTION_BIND_TO_MAP

	maxHealth = 200
	health = 200
	randomized = TRUE
	movement_base_speed = 10 / 4

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 15
	attack_sharp = TRUE

	base_pixel_x = -16
	icon_x_dimension = 64
	icon_y_dimension = 64

	say_list_type = /datum/say_list/panther
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

// Activate Noms!
/mob/living/simple_mob/vore/aggressive/panther

/datum/say_list/panther
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_hear = list("rawrs","rumbles","rowls","growls","roars")
	emote_see = list("stares ferociously", "snarls")
