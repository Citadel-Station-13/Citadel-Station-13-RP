/datum/category_item/catalogue/fauna/horse
	name = "Horse"
	desc = "A long-time companion of Humanity, the horse served as the \
	primary method of transportation for pre-industrial Humans for thousands \
	of years. That bond has remained even as technology has rendered the \
	creature obsolete. Kept for sentimentality and niche utility reasons, \
	the horse is still viable on planets where industrialization is not yet \
	possible."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/horse
	name = "horse"
	desc = "Don't look it in the mouth."
	tt_desc = "Equus ferus caballus"
	catalogue_data = list(/datum/category_item/catalogue/fauna/horse)

	icon_state = "horse"
	icon_living = "horse"
	icon_dead = "horse-dead"
	icon = 'icons/mob/vore.dmi'

	faction = "horse"
	maxHealth = 60
	health = 60
	randomized = TRUE
	mod_min = 100
	mod_max = 130

	movement_cooldown = 4 //horses are fast mkay.
	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = list("kicked")

	meat_amount = 4
	meat_type = /obj/item/reagent_containers/food/snacks/horsemeat
	bone_amount = 2
	hide_amount = 4
	exotic_amount = 2

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	mount_offset_x = 0

	say_list_type = /datum/say_list/horse
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

// Activate Noms!
/mob/living/simple_mob/vore/horse
	vore_active = 1
	vore_icons = SA_ICON_LIVING

/datum/say_list/horse
	speak = list("NEHEHEHEHEH","Neh?")
	emote_hear = list("snorts","whinnies")
	emote_see = list("shakes its head", "stamps a hoof", "looks around")
