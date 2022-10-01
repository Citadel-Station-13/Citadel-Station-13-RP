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
	movement_cooldown = 5
	see_in_dark = 3

	armor = list(
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

	melee_damage_upper = 12
	melee_damage_lower = 7
	attack_sharp = TRUE

	base_pixel_x = -16

	meat_amount = 10 //Infinite meat!
	bone_amount = 6
	hide_amount = 6
	hide_type = /obj/item/stack/hairlesshide

	say_list_type = /datum/say_list/hippo
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

// Activate Noms!
/mob/living/simple_mob/vore/hippo //I don't know why it's in a seperate line but everyone does it so i do it
	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 15
	vore_bump_emote = "lazily wraps its tentacles around"
	vore_standing_too = 1
	vore_ignores_undigestable = 0
	vore_default_mode = DM_HOLD
	vore_digest_chance = 10
	vore_escape_chance = 20
	vore_pounce_chance = 35 //it's hippo sized it doesn't care it just eats you
	vore_stomach_name = "rumen" //First stomach of a ruminant. It's where the pre digestion bacteria stuff happens. Very warm.
	vore_stomach_flavor	= "You are squeezed into the sweltering insides of the herbivore rumen."
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/vore/hippo/MouseDroppedOnLegacy(mob/living/M, mob/living/user)
	return

/datum/say_list/hippo
	speak = list("UUUUUUH")
	emote_hear = list("grunts","groans", "roars", "snorts")
	emote_see = list("shakes its head")
