/datum/category_item/catalogue/fauna/horror/Smiley
	name = "*!UT#ON#A#HAPPY#FAC)#@$"
	desc = "%WARNING% PROCESSING FAILURE! RETURN SCANNER TO A CENTRAL \
	ADMINISTRATOR FOR IMMEDIATE MAINTENANCE! %ERROR%"
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/horror/Smiley
	name = "???"
	desc = "A giant hand, with a large, smiling head on top."

	icon_state = "Smiley"
	icon_living = "Smiley"
	icon_dead = "s_head"
	icon_rest = "Smiley"
	icon = 'icons/mob/horror_show/GHPS.dmi'
	icon_gib = "generic_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/horror/Smiley)

	attack_sound = 'sound/h_sounds/holla.ogg'

	maxHealth = 175
	health = 175

	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 35
	grab_resist = 100

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("amashes")
	friendly = list("nuzzles", "boops", "bumps against", "leans on")


	say_list_type = /datum/say_list/Smiley
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/horror

	meat_amount = 5
	meat_type = /obj/item/reagent_containers/food/snacks/meat/human
	bone_amount = 10
	hide_amount = 5

/mob/living/simple_mob/horror/Smiley/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura/weak)

/mob/living/simple_mob/horror/Smiley/death()
	playsound(src, 'sound/h_sounds/lynx.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Helix/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)

/mob/living/simple_mob/horror/Helix/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Helix/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)

/mob/living/simple_mob/horror/Helix/attackby()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/datum/say_list/Smiley
	speak = list("Uuurrgh?","Aauuugghh...", "AAARRRGH!")
	emote_hear = list("shrieks horrifically", "groans in pain", "cries", "whines")
	emote_see = list("squeezes its fingers together", "shakes violently in place", "stares aggressively")
	say_maybe_target = list("Uuurrgghhh?")
	say_got_target = list("AAAHHHHH!")
