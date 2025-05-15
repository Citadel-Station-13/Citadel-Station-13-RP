/datum/category_item/catalogue/fauna/hippo
	name = "Hippo"
	desc = "A hardy savannah creature native to Earth, the only use for the \
	hippopotamus on the Frontier is entertainment. Often traded by rare animal \
	enthusiasts, the hippo is heavy, hardy, and aggressive."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/hippo
	name = "hippo"
	desc = "Mostly know for the spectacular hit of the live action movie Hungry Hungry Hippos."
	tt_desc = "Hippopotamus amphibius"
	catalogue_data = list(/datum/category_item/catalogue/fauna/hippo)

	icon_state = "hippo"
	icon_living = "hippo"
	icon_dead = "hippo_dead"
	icon_gib = "hippo_gib"
	icon = 'icons/mob/vore64x64.dmi'

	maxHealth = 200
	health = 200
	randomized = TRUE
	mod_min = 100
	mod_max = 150
	movement_base_speed = 10 / 5
	see_in_dark = 3

	armor_legacy_mob = list(
		"melee" = 15,//They thick as fuck boi
		"bullet" = 15,
		"laser" = 15,
		"energy" = 0,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 0)

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	attacktext = list("bit")

	legacy_melee_damage_upper = 12
	legacy_melee_damage_lower = 7
	attack_sharp = TRUE

	base_pixel_x = -16

	meat_amount = 10 //Infinite meat!
	bone_amount = 6
	hide_amount = 6
	hide_type = /obj/item/stack/hairlesshide

	say_list_type = /datum/say_list/hippo
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/retaliate

// Activate Noms!
/mob/living/simple_mob/vore/hippo //I don't know why it's in a seperate line but everyone does it so i do it

/mob/living/simple_mob/vore/hippo/MouseDroppedOnLegacy(mob/living/M, mob/living/user)
	return

/datum/say_list/hippo
	speak = list("UUUUUUH")
	emote_hear = list("grunts","groans", "roars", "snorts")
	emote_see = list("shakes its head")
