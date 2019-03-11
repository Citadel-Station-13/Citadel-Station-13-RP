/mob/living/simple_mob/animal/panther
	name = "panther"
	desc = "Runtime's larger, less cuddly cousin."
	tt_desc = "Panthera pardus"
	icon = 'icons/mob/vore64x64.dmi'
	icon_state = "panther"
	icon_living = "panther"
	icon_dead = "panther-dead"

	faction = "panther"
	maxHealth = 200
	health = 200

	ai_holder_type = /datum/ai_holder/simple_mob/panther
	say_list_type = /datum/say_list/panther

	speak_emote = list("growls", "roars")

	melee_damage_lower = 10
	melee_damage_upper = 30

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

	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 10
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_mob/animal/panther/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount

/datum/ai_holder/simple_mob/panther
	speak_chance = 2

/datum/say_list/panther
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	emote_hear = list("rawrs","rumbles","rowls")
	emote_see = list("stares ferociously", "snarls")
